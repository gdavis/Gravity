//
//  CoreGraphics+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/23/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "CoreGraphics+GDIAdditions.h"


void CGContextDrawInnerShadowWithPath(CGContextRef context, CGPathRef shapePath, UIColor *color, CGSize offset, CGFloat radius)
{
    // draw the inner shadow.
    CGRect rect = CGContextGetClipBoundingBox(context);
    // create offset for a shaper larger than the viewable path
    CGFloat outsideOffset = 10.f;
    
    // Fill this path
    UIColor *aColor = [UIColor clearColor];
    [aColor setFill];
    CGContextAddPath(context, shapePath);
    CGContextFillPath(context);
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow 
    CGMutablePathRef path = CGPathCreateMutable();
    // Draw a big rectange
    CGPathMoveToPoint(path, NULL, -outsideOffset, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, rect.size.width+outsideOffset*2, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, rect.size.width+outsideOffset*2, rect.size.height+outsideOffset*2);
    CGPathAddLineToPoint(path, NULL, -outsideOffset, rect.size.height+outsideOffset*2);
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, shapePath);
    CGPathCloseSubpath(path);
    
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, shapePath); 
    CGContextClip(context); 
    
    // Now setup the shadow properties on the context
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, offset, radius, [color CGColor]); 
    
    // Now fill the rectangle, so the shadow gets drawn
    aColor = [UIColor colorWithWhite:1.f alpha:1.f];
    [aColor setFill]; 
    CGContextSaveGState(context); 
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    // Release the paths
    CGPathRelease(path); 
}

void CGContextDrawGradientWithColors(CGContextRef context, CGRect rect, NSArray *colors, CGFloat locations[]) 
{
    // draw gradient fill for background
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (CGRectIsNull(rect)) {
        rect = CGContextGetClipBoundingBox(context);
    }

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}