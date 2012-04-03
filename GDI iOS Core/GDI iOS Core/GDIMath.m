//
//  GDIMath.h
//  GDI iOS Core
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "GDIMath.h"
#include "math.h"
#include "stdlib.h"


#define ARC4RANDOM_MAX      0x100000000
#define FEET_PER_METERS     3.280839895

CGPoint cartesianCoordinateFromPolar(float radius, float radians)
{
    float x,y;
    
    x = radius * cosf(radians);
    y = radius * sinf(radians);
    
    return CGPointMake(x, y);
}


// 1 foot * 1 meter/3.280839895 feet => meter
float metersToFeet(float meters)
{
    return meters * FEET_PER_METERS;
}

// 1 meter * 3.280839895 feet => feet
float feetToMeters(float feet)
{
    return feet / FEET_PER_METERS;
}


float degreesToRadians(float degrees)
{
    return degrees * M_PI / 180;
}


float radiansToDegrees(float radians)
{
    return radians * 180 / M_PI;
}


float max(float a, float b)
{
	if( a>b) return a;
	return b;
}


float min(float a, float b)
{
	if( a<b) return a;
	return b;
}


float randRange(float low, float high)
{
	return ((float)arc4random() / ARC4RANDOM_MAX * (high-low))+low;
}


float distance(float x, float y, float x2, float y2)
{
	return sqrtf(powf(x2-x, 2)+powf(y2-y, 2));
}


// Interpolate between angles.  This function takes care of cases where its correct to go the "short way"  from say, 5 degrees to 359 degrees
float degreesInterp(float angle1, float angle2, float n)
{
	
	angle1=modulus(angle1,360);
    angle2= modulus(angle2,360);
    
    if(angle1<0) angle1=360+angle1;
    if(angle2<0) angle2=360+angle2;  //Make all angles positive, 0-360
    
    if(fabs(angle1-angle2)>180 && angle1<angle2) angle1+=360;
    else if(fabs(angle1-angle2)>180 && angle2<angle1) angle2+=360;
	
	return interp(angle1, angle2, n);
}


float modulus(float a, float b)
{
	int result = (int)( a / b );
	return a - (float)( result ) * b;
}


float knotsToMPH(float knots)
{
	return knots*1.15077945;
}


float knotsToKPH(float knots)
{
	return knots*1.852;	
}


float inchesToCM(float in)
{
	return in*2.54;	
}


float farenheitToCelsius(float f)
{
	return((f - 32.0) * (5./9.) );
}


float celsiusToFarenheit(float c)
{
	return (c * (9./5.)) + 32.;
}


float clamp(float input, float low, float high)
{
	if(input<low) input=low;
	else if(input>high) input=high;
	return input;
}


float interp(float low,float high, float n)
{
	return low+  ((high-low)*n);
}
