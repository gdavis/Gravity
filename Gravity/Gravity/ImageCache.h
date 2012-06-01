//
//  ImageCache.h
//
//  Created by Grant Davis on 4/23/12.
//  Copyright 2009 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageCacheObject;
@protocol ImageCacheDelegate;

@interface ImageCache : NSObject {
}

@property (nonatomic, readonly) NSUInteger totalSizeInMemory;
@property (nonatomic, readonly) NSUInteger totalSizeOnDisk;

-(id)initWithMaxMemorySize:(NSUInteger)memoryMax diskSize:(NSUInteger)diskMax;

// inserts an image into the cache. 
-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key saveToDisk:(BOOL)saveToDisk;

// queries live memory to see if an image is stored by the specified key.
// this does not query image saved to disk.
-(UIImage*)imageForKey:(NSString*)key;

// clears memory
- (void)clear;

// deletes cached files from disk
- (void)clearDisk;

// queries the local file system to see if we've stored this image to disk.
// the completion handler is fired and passed the cached image object if found.
// otherwise, returns nil to the handler function.
- (void)queryDiskForImageKey:(NSString *)key delegate:(NSObject <ImageCacheDelegate>*)delegate userInfo:(NSDictionary *)info;

@end


@protocol ImageCacheDelegate
- (void)imageCacheQueryDidFinishWithImageCache:(ImageCacheObject *)imgCache userInfo:(NSObject *)info;
@end