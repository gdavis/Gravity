//
//  UIImageView+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/21/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIImageView+GDIAdditions.h"

@implementation UIImageView (GDIAdditions)

- (void)setImageInBackgroundThreadWithName:(NSString *)imageName
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [UIImage imageNamed:imageName];
        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }];
    [operation start];
}

- (void)setImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath
{
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
    }];
    [operation start];
}

@end
