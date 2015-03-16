//
//  UIColor+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/3/12.
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

#import "UIColor+GDIAdditions.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation UIColor (GDIAdditions)


+ (UIColor *)colorWithRGBHex:(uint)hex
{
    return [UIColor colorWithRGBHex:hex alpha:1.0f];
}


+ (UIColor *)colorWithRGBHex:(uint)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0f
                           green:((float)((hex & 0xFF00) >> 8))/255.0f
                            blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}


+ (UIColor *)colorWithARGBHex:(uint)hex
{
    float alpha = ((float)((hex & 0xFF000000) >> 24))/255.0f;
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0f
                           green:((float)((hex & 0xFF00) >> 8))/255.0f
                            blue:((float)(hex & 0xFF))/255.0f alpha:alpha];
}


+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha rgbDivisor:(CGFloat)divisor
{
    return [UIColor colorWithRed:red/divisor green:green/divisor blue:blue/divisor alpha:alpha/divisor];
}


+ (UIColor *)randomColor
{
    return [UIColor randomColorWithAlpha:1.0f];
}


+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha
{
    CGFloat red =  (CGFloat)arc4random()/(CGFloat)ARC4RANDOM_MAX;
    CGFloat blue = (CGFloat)arc4random()/(CGFloat)ARC4RANDOM_MAX;
    CGFloat green = (CGFloat)arc4random()/(CGFloat)ARC4RANDOM_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (UIColor *)interpolateBetweenColor:(UIColor *)color1 color:(UIColor *)color2 amount:(CGFloat)amount
{
    CGFloat red1;
    CGFloat red2;
    CGFloat green1;
    CGFloat green2;
    CGFloat blue1;
    CGFloat blue2;
    CGFloat alpha1;
    CGFloat alpha2;
    
    [color1 getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
    [color2 getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
    
    return [UIColor colorWithRed:interp(red1, red2, amount)
                           green:interp(green1, green2, amount)
                            blue:interp(blue1, blue2, amount)
                           alpha:interp(alpha1, alpha2, amount)];
}


float interp(float low,float high, float n)
{
    return low+  ((high-low)*n);
}


@end
