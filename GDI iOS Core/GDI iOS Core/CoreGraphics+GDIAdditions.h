//
//  CoreGraphics+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/23/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//



void CGContextDrawInnerShadowWithPath(CGContextRef context, CGPathRef shapePath, UIColor *color, CGSize offset, CGFloat radius);

void CGContextDrawGradientWithColors(CGContextRef context, CGRect rect, NSArray *colors, CGFloat locations[]);