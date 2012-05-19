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

#pragma mark - Image Manipulation

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
                                                      rect.size.height), opaque, 0.f);
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y) blendMode:kCGBlendModeCopy alpha:1.];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage* sourceImage = self; 
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    } 
    else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    }       
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2);
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
    } 
    else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2);
        CGContextTranslateCTM (bitmap, -targetWidth, 0);    
    } 
    else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } 
    else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI);
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}


#pragma mark Convenience Functions for Image Picking

- (UIImage *)rotateImage:(UIImage*)img imageOrientation:(UIImageOrientation)orient
{
    CGImageRef          imgRef = img.CGImage;
    CGFloat             width = CGImageGetWidth(imgRef);
    CGFloat             height = CGImageGetHeight(imgRef);
    CGAffineTransform   transform = CGAffineTransformIdentity;
    CGRect              bounds = CGRectMake(0, 0, width, height);
    CGSize              imageSize = bounds.size;
    CGFloat             boundHeight;
    
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        default:
            // image is not auto-rotated by the photo picker, so whatever the user
            // sees is what they expect to get. No modification necessary
            transform = CGAffineTransformIdentity;
            break;
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ((orient == UIImageOrientationDown) || (orient == UIImageOrientationRight) || (orient == UIImageOrientationUp)){
        // flip the coordinate space upside down
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
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


#pragma mark - Class Methods

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
