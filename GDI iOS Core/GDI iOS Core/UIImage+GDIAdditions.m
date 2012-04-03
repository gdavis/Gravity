//
//  UIImage+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/9/12.
//  Copyright (c) 2012 rabble+rouser. All rights reserved.
//

#import "UIImage+GDIAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (GDIAdditions)

- (UIImage *)imageWithTintColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -imageRect.size.height);

    // draw the image first
    CGContextDrawImage(context, imageRect, [self CGImage]);
    
    // then use the image as a mask to fill a color in.
    CGContextClipToMask(context, imageRect, [self CGImage]);
    [color set];
    CGContextFillRect(context, imageRect);
    
    // create and return the new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  newImage;
}

+ (UIImage*)imageOfView:(UIView*)view
{
	UIGraphicsBeginImageContext(view.bounds.size);    
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}


+ (UIImage*)imageFromMainBundleWithName:(NSString*)filename
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
