//
//  GDIColorTests.m
//  Gravity
//
//  Created by Grant Davis on 12/15/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Gravity/UIColor+GDIAdditions.h>


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
    XCTAssert([self roundNumber:expectedRed toPrecision:4] == [self roundNumber:actualRed toPrecision:4], @"Red color does not match expected color component");
    XCTAssert([self roundNumber:expectedBlue toPrecision:4] == [self roundNumber:actualBlue toPrecision:4], @"Blue color does not match expected color component");
    XCTAssert([self roundNumber:expectedGreen toPrecision:4] == [self roundNumber:actualGreen toPrecision:4], @"Green color does not match expected color component");
    XCTAssert(1.0f == [self roundNumber:actualAlpha toPrecision:4], @"Alpha color does not match expected color component");
}


- (void)testRGBWithAlphaColorConversion
{
    UIColor *color = [UIColor colorWithRGBHex:0x589a93 alpha:0.4f];
    CGFloat max = 255.f;
    CGFloat expectedRed = 88.f/max;
    CGFloat expectedGreen = 154.f/max;
    CGFloat expectedBlue = 147.f/max;
    double expectedAlpha = 102.0/max;
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [color getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssert([self roundNumber:expectedRed toPrecision:4] == [self roundNumber:actualRed toPrecision:4], @"Red color does not match expected color component");
    XCTAssert([self roundNumber:expectedBlue toPrecision:4] == [self roundNumber:actualBlue toPrecision:4], @"Blue color does not match expected color component");
    XCTAssert([self roundNumber:expectedGreen toPrecision:4] == [self roundNumber:actualGreen toPrecision:4], @"Green color does not match expected color component");
    XCTAssert([self roundNumber:expectedAlpha toPrecision:4] == [self roundNumber:actualAlpha toPrecision:4], @"Alpha color does not match expected color component");
}


- (void)testRGBAHexColorConversion
{
    UIColor *color = [UIColor colorWithARGBHex:0x68589a93];
    CGFloat max = 255.f;
    CGFloat expectedRed = 88.f/max;
    CGFloat expectedGreen = 154.f/max;
    CGFloat expectedBlue = 147.f/max;
    CGFloat expectedAlpha = 104.f/max;
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [color getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssert([self roundNumber:expectedRed toPrecision:4] == [self roundNumber:actualRed toPrecision:4], @"Red color does not match expected color component");
    XCTAssert([self roundNumber:expectedBlue toPrecision:4] == [self roundNumber:actualBlue toPrecision:4], @"Blue color does not match expected color component");
    XCTAssert([self roundNumber:expectedGreen toPrecision:4] == [self roundNumber:actualGreen toPrecision:4], @"Green color does not match expected color component");
    XCTAssert([self roundNumber:expectedAlpha toPrecision:4] == [self roundNumber:actualAlpha toPrecision:4], @"Alpha color does not match expected color component");
}


- (void)testRGBColorWithDivisor
{
    CGFloat max = 255.f;
    CGFloat expectedRed = 88.f/max;
    CGFloat expectedGreen = 154.f/max;
    CGFloat expectedBlue = 147.f/max;
    CGFloat expectedAlpha = 102.f/max;
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    UIColor *color = [UIColor colorWithRed:88.f green:154.f blue:147.f alpha:102.f rgbDivisor:max];
    [color getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssert([self roundNumber:expectedRed toPrecision:4] == [self roundNumber:actualRed toPrecision:4], @"Red color does not match expected color component");
    XCTAssert([self roundNumber:expectedBlue toPrecision:4] == [self roundNumber:actualBlue toPrecision:4], @"Blue color does not match expected color component");
    XCTAssert([self roundNumber:expectedGreen toPrecision:4] == [self roundNumber:actualGreen toPrecision:4], @"Green color does not match expected color component");
    XCTAssert([self roundNumber:expectedAlpha toPrecision:4] == [self roundNumber:actualAlpha toPrecision:4], @"Alpha color does not match expected color component");
}


- (BOOL)isValue:(CGFloat)value betweenStart:(CGFloat)start end:(CGFloat)end
{
    return value >= start && value <= end;
}


- (void)testRandomColor
{
    UIColor *randomColor = [UIColor randomColor];
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [randomColor getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssertTrue([self isValue:actualRed betweenStart:0.f end:1.f], @"Unexpected color components");
    XCTAssertTrue([self isValue:actualBlue betweenStart:0.f end:1.f], @"Unexpected color components");
    XCTAssertTrue([self isValue:actualGreen betweenStart:0.f end:1.f], @"Unexpected color components");
    XCTAssertTrue([self roundNumber:actualAlpha toPrecision:4] == 1.f, @"Unexpected color components");
}


- (void)testRandomColorWithAlpha
{
    CGFloat expectedAlpha = 0.645f;
    UIColor *randomColor = [UIColor randomColorWithAlpha:expectedAlpha];
    CGFloat actualRed;
    CGFloat actualGreen;
    CGFloat actualBlue;
    CGFloat actualAlpha;
    [randomColor getRed:&actualRed green:&actualGreen blue:&actualBlue alpha:&actualAlpha];
    XCTAssertTrue([self isValue:actualRed betweenStart:0.f end:1.f], @"Unexpected color components");
    XCTAssertTrue([self isValue:actualBlue betweenStart:0.f end:1.f], @"Unexpected color components");
    XCTAssertTrue([self isValue:actualGreen betweenStart:0.f end:1.f], @"Unexpected color components");
    XCTAssertTrue(actualAlpha == expectedAlpha, @"Unexpected color components");
}


- (double)roundNumber:(double)num toPrecision:(int)precision
{
    double exact = num * pow(10, precision);
    double floor = floorl(exact);
    
    if ((floor + 1) <= (exact + 0.50)) {
        return (double) ((floor + 1) / pow(10, precision));
    }
    else
    {
        return (double) (floor / pow(10, precision));
    }
}


@end
