//
//  ImageCacheObject.m
//  YellowJacket
//
//  Created by Wayne Cochran on 7/26/09.
//  Copyright 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "ImageCacheObject.h"

@implementation ImageCacheObject

@synthesize size;
@synthesize timeStamp;
@synthesize image;

-(id)initWithSize:(NSUInteger)sz image:(UIImage*)anImage{
    if (self = [super init]) {
        size = sz;
        timeStamp = [NSDate date];
        image = anImage;
    }
    return self;
}

-(void)resetTimeStamp {
    timeStamp = [NSDate date];
}

@end
