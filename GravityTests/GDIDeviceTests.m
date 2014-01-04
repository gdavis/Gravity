//
//  GDIDeviceTests.m
//  Gravity
//
//  Created by Grant Davis on 1/3/14.
//  Copyright (c) 2014 Grant Davis Interactive, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface GDIDeviceTests : XCTestCase

@end

@implementation GDIDeviceTests

- (void)testIsRetina
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    BOOL isRetina = [UIDevice isRetina];
    XCTAssertTrue(scale > 1.f ? isRetina == YES : isRetina == NO,
                  @"isRetina does not match the expected value");
}

- (void)testDeviceScreenSize
{
    CGRect windowRect = [[UIApplication sharedApplication] keyWindow].frame;
    GDIDeviceScreenSize screenSize = [UIDevice deviceScreenSize];
    if (CGSizeEqualToSize(windowRect.size, CGSizeMake(320.f, 480.f))) {
        XCTAssertTrue(screenSize == GDIDeviceScreenSize320x480, @"Device screen size does not match expected dimensions");
    }
    else if (CGSizeEqualToSize(windowRect.size, CGSizeMake(320.f, 568.f))) {
        XCTAssertTrue(screenSize == GDIDeviceScreenSize320x568, @"Device screen size does not match expected dimensions");
    }
    else if (CGSizeEqualToSize(windowRect.size, CGSizeMake(768.f, 1024.f))) {
        XCTAssertTrue(screenSize == GDIDeviceScreenSize768x1024, @"Device screen size does not match expected dimensions");
    }
}

- (void)testIsiOS7
{
    BOOL isiOS7 = [UIDevice isOS7OrLater];
    BOOL expectedValue = floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1;
    XCTAssertTrue(expectedValue == isiOS7, @"iOS7 flag does not match expected value");
}

@end
