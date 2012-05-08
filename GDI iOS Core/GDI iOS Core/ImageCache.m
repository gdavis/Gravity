//
//  ImageCache.m
//
//  Created by Grant Davis on 4/23/12.
//  Copyright 2009 Grant Davis Interactive, LLC. All rights reserved.
//

#import "ImageCache.h"
#import "ImageCacheObject.h"
#import <CommonCrypto/CommonDigest.h>

#define kImageCacheDirectoryName @"ImageCache"
static NSInteger cacheMaxCacheAge = 60*60*24*14; // 2 weeks

@interface ImageCache() {
    NSUInteger _maxSizeInMemory;
    NSUInteger _maxSizeOnDisk;
    NSMutableDictionary *_memoryCache;
    NSString *_diskCachePath;
    NSOperationQueue *_cacheInQueue;
    NSOperationQueue *_cacheOutQueue;
    NSUInteger _totalDiskSize;
}

- (void)determineUsedDiskSpace;
- (void)queryDiskCacheOperation:(NSMutableDictionary *)arguments;
- (void)freeMemoryForImageWithSize:(NSUInteger)size;
- (void)freeDiskSpaceForImageWithSize:(NSUInteger)size;
- (void)clearExpiredItemsFromDisk;
- (void)cleanupDisk;

@end


@implementation ImageCache
@synthesize totalSizeInMemory;
@synthesize totalSizeOnDisk;


-(id)initWithMaxMemorySize:(NSUInteger)memoryMax diskSize:(NSUInteger)diskMax  
{    
    if (self = [super init]) {
        
        // initialize variables
        totalSizeInMemory = 0;
        _maxSizeInMemory = memoryMax;
        _maxSizeOnDisk = diskMax;
        _memoryCache = [[NSMutableDictionary alloc] init];
        
        // create operation queues
        _cacheInQueue = [[NSOperationQueue alloc] init];
        _cacheInQueue.maxConcurrentOperationCount = 1;
        _cacheOutQueue = [[NSOperationQueue alloc] init];
        _cacheOutQueue.maxConcurrentOperationCount = 1;
        
        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kImageCacheDirectoryName];
        
        // create directory for our images if it does not exist
        if (![[NSFileManager defaultManager] fileExistsAtPath:_diskCachePath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:_diskCachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        // low memory warning
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(clear) 
                                                     name:UIApplicationDidReceiveMemoryWarningNotification 
                                                   object:nil];
        
        // cleanup disk
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cleanupDisk)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}


- (void)dealloc
{
    [_cacheInQueue cancelAllOperations];
    [_cacheOutQueue cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)determineUsedDiskSpace
{
    NSUInteger totalDiskSize = 0;
    NSError *error = nil;
    NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_diskCachePath error:&error];
    
    if (error) {
        NSLog(@"error loading images in cache directory: %@", error);
    }
    
    for (NSString *filePath in images) {
        
        NSString *imageFilePath = [_diskCachePath stringByAppendingPathComponent:filePath];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imageFilePath error:&error];
        NSString *fileSize = [attributes objectForKey:NSFileSize];
        if (error) {
            NSLog(@"error getting attributes of file at path: %@", filePath);
        }
        else {
            totalDiskSize += [fileSize integerValue];
        }
    }
    _totalDiskSize = totalDiskSize;
}


-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key saveToDisk:(BOOL)saveToDisk {
    ImageCacheObject *object = [[ImageCacheObject alloc] initWithSize:sz image:image];

    // free memory
    [self freeMemoryForImageWithSize:sz];
    
    // update total memory size
    totalSizeInMemory += sz;
    
    // save cache object in memory
    [_memoryCache setObject:object forKey:key];
    
    // save image to disk if specified
    if (saveToDisk) {
        [_cacheInQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self
                                                                         selector:@selector(storeKeyWithDataToDisk:)
                                                                           object:[NSArray arrayWithObject:key]]];
    }
}


- (void)freeMemoryForImageWithSize:(NSUInteger)size
{
    if (totalSizeInMemory < _maxSizeInMemory) {
        return;
    }
    
//    NSLog(@"****");
//    NSLog(@"freeMemoryForImageWithSize starting size: %i", totalSizeInMemory);
    NSUInteger removeCount = 0;
    while (totalSizeInMemory + size > _maxSizeInMemory) {
        NSDate *oldestTime;
        NSString *oldestKey;
        for (NSString *key in [_memoryCache allKeys]) {
            ImageCacheObject *obj = [_memoryCache objectForKey:key];
            if (oldestTime == nil || [obj.timeStamp compare:oldestTime] == NSOrderedAscending) {
                oldestTime = obj.timeStamp;
                oldestKey = key;
            }
        }
        if (oldestKey == nil) {
            break; // shoudn't happen
        }
        ImageCacheObject *obj = [_memoryCache objectForKey:oldestKey];
        totalSizeInMemory -= obj.size;
        [_memoryCache removeObjectForKey:oldestKey];
        removeCount++;
    }
//    NSLog(@"freeMemoryForImageWithSize removed %i images with ending size: %i", removeCount, totalSizeInMemory);
//    NSLog(@"****");
}


- (void)freeDiskSpaceForImageWithSize:(NSUInteger)size
{
    // don't free space if we don't need to
    if (_totalDiskSize < _maxSizeOnDisk) {
        return;
    }
    
//    NSLog(@"****");
//    NSLog(@"freeDiskSpaceForImageWithSize starting size: %i", _totalDiskSize);
    
    NSUInteger totalDiskSize = _totalDiskSize;    
    NSError *error = nil;
    NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_diskCachePath error:&error];
    
    if (error) {
        NSLog(@"error loading images in cache directory: %@", error);
    }
    NSUInteger removeCount = 0;
    for (NSString *filePath in images) {
        
        NSString *imageFilePath = [_diskCachePath stringByAppendingPathComponent:filePath];
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imageFilePath error:&error];
        NSString *fileSize = [attributes objectForKey:NSFileSize];
        if (error) {
            NSLog(@"error getting attributes of file at path: %@", filePath);
        }
        else {
            
            if (totalDiskSize > _maxSizeOnDisk) {
                
                // remove item at this path
                totalDiskSize -= [fileSize integerValue];
                [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:&error];
                removeCount++;
                
                if (error) {
                    NSLog(@"error deletinge file at path: %@", filePath);
                }
            }
            else {
                // if we're below the max disk size, stop removing items.
                break;
            }
        }
    }
    _totalDiskSize = totalDiskSize;
}


- (void)storeKeyWithDataToDisk:(NSArray *)keyAndData
{
    // Can't use defaultManager another thread
    NSString *key = [keyAndData objectAtIndex:0];
    NSData *data = nil;
    NSString *imageSavePath = [self cachePathForKey:key];
    
    // If no data representation given, convert the UIImage in JPEG and store it
    // This trick is more CPU/memory intensive and doesn't preserve alpha channel
    UIImage *image = [self imageForKey:key];
    if (image) {            
        
        // pull out extension to see how we should handle saving the image
        NSString *extension = [[key pathExtension] lowercaseString];
        
        // check for pngs and gifs
        if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"gif"]) {
            data = UIImagePNGRepresentation(image);
        }
        else {
            data = UIImageJPEGRepresentation(image, (CGFloat)1.0);
        }
    }
    
    if (data) {
        
        // save image to file
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:imageSavePath 
                                                               contents:data 
                                                             attributes:nil];
        
        // handle failure
        if (!success) {
            NSLog(@"failed to save to disk using path: %@", imageSavePath);
        }
        // otherwise, increment our disk size count with the new data length
        else {
            _totalDiskSize += data.length;
        }
    }
    else {
        NSLog(@"No data to save to disk!");
    }
}


- (NSString *)cachePathForKey:(NSString *)key
{
    NSString *imageExtension = [key pathExtension];
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x.%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15], imageExtension];
    return [_diskCachePath stringByAppendingPathComponent:filename];
}


-(UIImage*)imageForKey:(NSString*)key 
{    
    UIImage *image = nil;
    
    // return object from memory
    ImageCacheObject *object = [_memoryCache objectForKey:key];
    if (object) {
        image = object.image;
        [object resetTimeStamp];
    }
    
    return image;
}


- (void)queryDiskForImageKey:(NSString *)key delegate:(NSObject <ImageCacheDelegate>*)delegate userInfo:(NSDictionary *)info
{
    if (!key) {
        if ([delegate respondsToSelector:@selector(imageCacheQueryDidFinishWithImageCache:userInfo:)]) {
            [delegate imageCacheQueryDidFinishWithImageCache:nil userInfo:info];
        }
        return;
    }
    
    // First check the in-memory cache...
    ImageCacheObject *cacheObject = [_memoryCache objectForKey:key];
    if (cacheObject) {
        if ([delegate respondsToSelector:@selector(imageCacheQueryDidFinishWithImageCache:userInfo:)]) {
            [delegate imageCacheQueryDidFinishWithImageCache:cacheObject userInfo:info];
        }
        return;
    }
    
    // then queue an operation to check the disk for an existing cached file
    NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
    [arguments setObject:key forKey:@"key"];
    [arguments setObject:delegate forKey:@"delegate"];
    [arguments setObject:info forKey:@"userInfo"];
    [_cacheOutQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(queryDiskCacheOperation:) object:arguments]];
}


- (void)queryDiskCacheOperation:(NSMutableDictionary *)arguments
{
    NSString *key = [arguments objectForKey:@"key"];
    NSString *cachePath = [self cachePathForKey:key];
       
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        
        NSData *imageData = [NSData dataWithContentsOfFile:cachePath];
        if (imageData) {        
            
            // free memory to make room for new image from disk
            [self freeMemoryForImageWithSize:imageData.length];
            
            // store image in memory
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            ImageCacheObject *imageCacheObject = [[ImageCacheObject alloc] initWithSize:imageData.length image:image];      
            [_memoryCache setObject:imageCacheObject forKey:key];
            [arguments setObject:imageCacheObject forKey:@"cache"];
        }
    }
    
    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:arguments waitUntilDone:NO];
}


- (void)notifyDelegate:(NSDictionary *)arguments
{
    NSObject <ImageCacheDelegate>*delegate = [arguments objectForKey:@"delegate"];
    
    // pull out image cache object and send to delegate
    ImageCacheObject *imageCacheObject = [arguments objectForKey:@"cache"];
    if ([delegate respondsToSelector:@selector(imageCacheQueryDidFinishWithImageCache:userInfo:)]) {
        [delegate imageCacheQueryDidFinishWithImageCache:imageCacheObject userInfo:[arguments objectForKey:@"userInfo"]];
    }
}


- (void)clear
{
	[_memoryCache removeAllObjects];
	totalSizeInMemory = 0;
}


- (void)clearDisk
{
    NSError *error = nil;
    NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_diskCachePath error:&error];
    
    if (error) {
        NSLog(@"error loading images in cache directory: %@", error);
    }
    NSUInteger removeCount = 0;
    for (NSString *filePath in images) {
        
        NSString *imageFilePath = [_diskCachePath stringByAppendingPathComponent:filePath];
        if (error) {
            NSLog(@"error getting attributes of file at path: %@", filePath);
        }
        else {
            [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:&error];
            removeCount++;
            
            if (error) {
                NSLog(@"error deleting file at path: %@", filePath);
            }
        }
    }
    totalSizeOnDisk = 0;
}

- (void)cleanupDisk
{
    // calculate the size of our cache
    [self determineUsedDiskSpace];
    
    // first clear all expired cache items
    [self clearExpiredItemsFromDisk];
    
    // then free space until we are under the max limit
    [self freeDiskSpaceForImageWithSize:0];
}


- (void)clearExpiredItemsFromDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:_diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [_diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}


@end
