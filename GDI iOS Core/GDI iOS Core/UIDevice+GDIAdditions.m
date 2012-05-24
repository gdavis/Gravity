//
//  UIDevice+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/24/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIDevice+GDIAdditions.h"

@implementation UIDevice (GDIAdditions)

// adopted from: http://stackoverflow.com/questions/3504173/detect-retina-display
+ (BOOL)isRetina
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES 
        && [[UIScreen mainScreen] scale] == 2.00) {
        return YES;
    }
    return NO;
}

@end
