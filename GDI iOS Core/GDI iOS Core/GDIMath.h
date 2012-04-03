//
//  GDIMath.h
//  GDI iOS Core
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

CGPoint cartesianCoordinateFromPolar(float radius, float radians);

float metersToFeet(float meters);
float feetToMeters(float feet);

float degreesToRadians(float degrees);
float radiansToDegrees(float radians);
float randRange(float low, float high);
float interp(float low,float high, float n);
float clamp(float input, float low, float high);
float modulus(float a, float b);
float degreesInterp(float angle1, float angle2, float n);
float farenheitToCelsius(float f);
float celsiusToFarenheit(float c);
float inchesToCM(float in);
float knotsToMPH(float knots);
float knotsToKPH(float knots);
float distance(float x, float y, float x2, float y2);

float max(float a, float b);
float min(float a, float b);