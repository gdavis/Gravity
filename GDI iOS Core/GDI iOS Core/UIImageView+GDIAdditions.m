//
//  UIImageView+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/21/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIImageView+GDIAdditions.h"

@interface UIImageView(GDIAdditionsPrivate)
+ (NSOperationQueue *)imageBackgroundOperationQueue;
- (void)loadImageInBackgroundThreadWithName:(NSString *)name;
- (void)loadImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath;
@end


@implementation UIImageView (GDIAdditionsPrivate)

+ (NSOperationQueue*)imageBackgroundOperationQueue
{
    static NSOperationQueue *operationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 1;
    });
    return operationQueue;
}

- (void)loadImageInBackgroundThreadWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

- (void)loadImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath
{
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

@end

@implementation UIImageView (GDIAdditions)

- (void)setImageInBackgroundThreadWithName:(NSString *)imageName
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                            selector:@selector(loadImageInBackgroundThreadWithName:) 
                                                                              object:imageName];
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [[UIImageView imageBackgroundOperationQueue] addOperation:operation];
}

- (void)setImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                            selector:@selector(loadImageInBackgroundThreadWithContentsOfFile:) 
                                                                              object:filePath];
    operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    [[UIImageView imageBackgroundOperationQueue] addOperation:operation];
}



@end
