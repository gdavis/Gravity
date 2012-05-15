//
//  GDISignatureCaptureView.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDISignatureCaptureView.h"

@interface GDISignatureCaptureView() {
    NSMutableArray *_points;
    CGMutablePathRef _signaturePath;
    CGMutablePathRef _linePath;
}

- (void)initialize;

// utility methods for creating splines
NSArray* splineInterpolatePoints(NSArray *sourceArr, NSInteger smoothingSteps);
CGPoint spline(CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3, CGFloat t);

@end

@implementation GDISignatureCaptureView
@synthesize strokeWidth;
@synthesize strokeColor;
@synthesize smoothing;

#pragma mark - Setup & Teardown

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)initialize
{
    self.clearsContextBeforeDrawing = NO;
    
    _signaturePath = CGPathCreateMutable();
    strokeWidth = 2.f;
    strokeColor = [UIColor blackColor];
    smoothing = 5;
}


- (void)dealloc
{
    CGPathRelease(_signaturePath);
}

#pragma mark - Public Methods

- (UIImage*)imageOfSignature
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1.f);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}


- (void)clear
{
    CGPathRelease(_signaturePath);
    _signaturePath = CGPathCreateMutable();
    [self setNeedsDisplay];
}


#pragma mark - Overrides

- (void)setStrokeWidth:(CGFloat)aStrokeWidth
{
    strokeWidth = aStrokeWidth;
    [self setNeedsDisplay];
}


- (void)setStrokeColor:(UIColor *)aStrokeColor
{
    strokeColor = aStrokeColor;
    [self setNeedsDisplay];
}


- (void)setSmoothing:(NSUInteger)aSmoothing
{
    smoothing = aSmoothing;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, strokeColor.CGColor);
    CGContextSetLineWidth(ctx, strokeWidth);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextAddPath(ctx, _signaturePath);
    CGContextStrokePath(ctx);
    if (_linePath) {
        CGContextAddPath(ctx, _linePath);
        CGContextStrokePath(ctx);
    }
}


- (void)addTouch:(CGPoint)touchPoint
{
    // add point to storage
    [_points addObject:[NSValue valueWithCGPoint:touchPoint]];
    
    // add point to line
    CGPathAddLineToPoint(_linePath, NULL, touchPoint.x, touchPoint.y);
}


#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        
        // create new points array for this line
        _points = [NSMutableArray array];
        
        // create a path for the line
        _linePath = CGPathCreateMutable();
        
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        [_points addObject:[NSValue valueWithCGPoint:touchPoint]];
        
        // move path to starting point
        CGPathMoveToPoint(_linePath, NULL, touchPoint.x, touchPoint.y);
    }
    if ([touches count] == 3) {
        [self clear];
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        [self addTouch:touchPoint];
        [self setNeedsDisplay];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self];
        [self addTouch:touchPoint];
        
        // here we take the points recorded and then run them through
        // a spline method to create a smoothed set of points.
        // with those, we'll create a new path that will be added
        // to the signature path as a final line.
        NSArray *interpolatedPoints = splineInterpolatePoints(_points, smoothing);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPoint firstPoint = [[interpolatedPoints objectAtIndex:0] CGPointValue]; 
        
        // move to the first point
        CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
        
        // then add points to create the line
        for (int i=1; i< interpolatedPoints.count; i++) {
            CGPoint point = [[interpolatedPoints objectAtIndex:i] CGPointValue];
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
        }
        // add the smoothed path to the final signature path
        CGPathAddPath(_signaturePath, NULL, path);
        
        // remove the temporary path
        CGPathRelease(path);
        CGPathRelease(_linePath);
        _linePath = nil;
        
        // refresh the display
        [self setNeedsDisplay];
        _points = nil;
    }
}



NSArray* splineInterpolatePoints(NSArray *sourceArr, NSInteger smoothingSteps)
{
    smoothingSteps = smoothingSteps < 0 ? 1 : smoothingSteps;
    NSMutableArray *interpolatedPoints = [NSMutableArray arrayWithCapacity:sourceArr.count];
    for (int i=0; i < sourceArr.count; i++) {
        CGPoint p0 = [[sourceArr objectAtIndex:fmax(i - 1, 0)] CGPointValue];
        CGPoint p1 = [[sourceArr objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[sourceArr objectAtIndex:fminf((i + 1), sourceArr.count-1)] CGPointValue];
        CGPoint p3 = [[sourceArr objectAtIndex:fminf((i + 2), sourceArr.count-1)] CGPointValue];
        
        for (int j=0; j<smoothingSteps; j++) {
            CGFloat progress = (float)j / (float)smoothingSteps;
            CGPoint interpolatedPoint = spline(p0, p1, p2, p3, progress);
            [interpolatedPoints addObject:[NSValue valueWithCGPoint:interpolatedPoint]];
        }
    }
    return interpolatedPoints;
}


// spline adapted for use with objective-c from:
// http://www.mvps.org/directx/articles/catmull/
CGPoint spline(CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3, CGFloat t)
{
    return CGPointMake( 0.5 * ((2*p1.x) + t * (( -p0.x + p2.x) +
                                               t * ((2*p0.x -5*p1.x + 4*p2.x - p3.x) +
                                                    t * (-p0.x + 3*p1.x - 3*p2.x + p3.x)))), 
                       0.5 * ((2 * p1.y) + t * (( -p0.y + p2.y) +
                                                t * ((2*p0.y -5*p1.y +4*p2.y -p3.y) +
                                                     t * (  -p0.y +3*p1.y -3*p2.y +p3.y)))));
}

@end
