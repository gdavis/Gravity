//
//  ImageCacheObject.h
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageCacheObject : NSObject {
    NSUInteger size;    // size in bytes of image data
    NSDate *timeStamp;  // time of last access
    UIImage *image;     // cached image
}

@property (nonatomic, readonly) NSUInteger size;
@property (nonatomic, strong, readonly) NSDate *timeStamp;
@property (nonatomic, strong, readonly) UIImage *image;

-(id)initWithSize:(NSUInteger)sz image:(UIImage*)anImage;
-(void)resetTimeStamp;

@end
