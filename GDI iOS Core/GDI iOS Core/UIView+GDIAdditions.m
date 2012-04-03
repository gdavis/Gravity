//
//  UIView+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/15/12.
//  Copyright (c) 2012 rabble+rouser. All rights reserved.
//

#import "UIView+GDIAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (GDIAdditions)
@dynamic frameLeft;
@dynamic frameRight;
@dynamic frameBottom;
@dynamic frameTop;
@dynamic frameWidth;
@dynamic frameHeight;
@dynamic frameOrigin;

#pragma mark - Frame Accessors


- (CGFloat)frameLeft
{
    return self.frame.origin.x;
}

- (void)setFrameLeft:(CGFloat)frameLeft
{
    self.frame = CGRectMake(frameLeft, self.frameTop, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)frameRight
{
    self.frame = CGRectMake(frameRight - self.frameWidth, self.frameTop, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)frameBottom
{
    self.frame = CGRectMake(self.frameLeft, frameBottom - self.frameHeight, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameTop
{
    return self.frame.origin.y;
}

- (void)setFrameTop:(CGFloat)frameTop
{
    self.frame = CGRectMake(self.frameLeft, frameTop, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    self.frame = CGRectMake(self.frameLeft, self.frameTop, frameWidth, self.frameHeight);
}


- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    self.frame = CGRectMake(self.frameLeft, self.frameTop, self.frameWidth, frameHeight);
}


- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin
{
    self.frame = CGRectMake(frameOrigin.x, frameOrigin.y, self.frameWidth, self.frameHeight);
}

#pragma mark - Instance Methods

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (UIImage*)imageOfView
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

#pragma mark - Class Methods

+ (UIView *)viewFromNib:(NSString*)nibName
{
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    UIView *view = nil;
    for (UIView *nibView in nibItems) {
        view = nibView;
        break;
    }
    return view;
}

@end
