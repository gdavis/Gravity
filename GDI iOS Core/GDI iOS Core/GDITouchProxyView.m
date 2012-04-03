//
//  GDITouchProxyViewView.m
//  GDI iOS Core
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GDITouchProxyView.h"

@implementation GDITouchProxyView
@synthesize delegate = _delegate;

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchBeganAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchBeganAtPoint:[touch locationInView:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if ([_delegate respondsToSelector:@selector(gestureView:touchMovedToPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchMovedToPoint:[touch locationInView:self]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchEndedAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchEndedAtPoint:[touch locationInView:self]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchEndedAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchEndedAtPoint:[touch locationInView:self]];
    }
}


@end
