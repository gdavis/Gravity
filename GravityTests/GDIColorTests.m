//
//  GDIColorTests.m
//  Gravity
//
//  Created by Grant Davis on 12/15/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+GDIAdditions.h"

@interface GDIColorTests : XCTestCase

@end

@implementation GDIColorTests

- (void)testRGBHexColorConversion
{
    UIColor *color = [UIColor colorWithRGBHex:0x589a93];
    CGFloat max = 255.f;
    CGFloat expectedRed = 88.f/max;
    CGFloat expectedGreen = 154.f/max;
    CGFloat expectedBlue = 147.f/max;
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [color getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssertTrue((expectedRed == actualRed)
                 && (expectedGreen == actualGreen)
                 && (expectedBlue == actualBlue), @"Expected color components do not match result components.");
}

- (void)testRGBWithAlphaColorConversion
{
    UIColor *color = [UIColor colorWithRGBHex:0x589a93 alpha:0.4f];
    CGFloat max = 255.f;
    CGFloat expectedRed = 88.f/max;
    CGFloat expectedGreen = 154.f/max;
    CGFloat expectedBlue = 147.f/max;
    CGFloat expectedAlpha = 102.f/max;
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [color getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssertTrue((expectedRed == actualRed)
                 && (expectedGreen == actualGreen)
                 && (expectedBlue == actualBlue)
                 && (expectedAlpha == actualAlpha), @"Expected color components do not match result components.");
}

- (void)testRGBAHexColorConversion
{
    UIColor *color = [UIColor colorWithARGBHex:0x66589a93];
    CGFloat max = 255.f;
    CGFloat expectedRed = 88.f/max;
    CGFloat expectedGreen = 154.f/max;
    CGFloat expectedBlue = 147.f/max;
    CGFloat expectedAlpha = 102.f/max;
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [color getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssertTrue((expectedRed == actualRed)
                 && (expectedGreen == actualGreen)
                 && (expectedBlue == actualBlue)
                 && (expectedAlpha == actualAlpha), @"Expected color components do not match result components.");
}

@end
