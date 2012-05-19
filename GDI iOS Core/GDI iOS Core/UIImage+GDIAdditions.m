//
//  UIImage+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/9/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in the 
//  Software without restriction, including without limitation the rights to use, 
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
//  Software, and to permit persons to whom the Software is furnished to do so, 
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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


- (UIImage *)imageCroppedToRect:(CGRect)rect
{
    return [self imageCroppedToRect:rect opaque:NO];
}


- (UIImage *)imageCroppedToRect:(CGRect)rect opaque:(BOOL)opaque
{    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width,
                                                      rect.size.height), YES, 0.f);
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y) blendMode:kCGBlendModeCopy alpha:1.];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (CGRect)transformRect:(CGRect)rect forEXIFOrientation:(NSUInteger)orientation
{
    CGAffineTransform translation = CGAffineTransformIdentity;
    CGFloat rotation = 0;
    
    switch (orientation) {
        case 8: { // EXIF #8
            
            translation = CGAffineTransformMakeTranslation(self.size.height, 0.0);
            rotation = M_PI_2;
            break;
        }
        case 3: { // EXIF #3
            
            translation = CGAffineTransformMakeTranslation(self.size.width, self.size.height);
            rotation = M_PI;
            break;
        }
        case 6: { // EXIF #6
            
            translation = CGAffineTransformMakeTranslation(0.0, self.size.width);
            rotation = M_PI + M_PI_2;
            break;
        }
        case 1: // EXIF #1 - do nothing
        default: // EXIF 2,4,5,7 - ignore
            return rect;
    }
    
    return CGRectApplyAffineTransform(rect, CGAffineTransformRotate(translation, rotation));
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
