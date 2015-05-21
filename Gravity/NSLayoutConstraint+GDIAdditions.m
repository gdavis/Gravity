//
//  NSLayoutConstraint+GDIAdditions.m
//  Gravity
//
//  Created by Grant Davis on 4/30/15.
//  Copyright (c) 2015 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSLayoutConstraint+GDIAdditions.h"


@implementation NSLayoutConstraint (GDIAdditions)

+ (NSArray *)constraintsToFillSuperviewWithView:(UIView *)view
{
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:kNilOptions metrics:nil views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:kNilOptions metrics:nil views:views]];
    return [constraints copy];
}


+ (NSArray *)constraintsToSizeView:(UIView *)view size:(CGSize)size
{
    return [self constraintsToSizeView:view size:size priority:UILayoutPriorityRequired];
}


+ (NSArray *)constraintsToSizeView:(UIView *)view size:(CGSize)size priority:(UILayoutPriority)priority
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size.width];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:size.height];
    heightConstraint.priority = priority;
    widthConstraint.priority = priority;
    return @[widthConstraint, heightConstraint];
}


+ (NSArray *)constraintsToCenterView:(UIView *)view inView:(UIView *)superView
{
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    return @[centerX, centerY];
}

@end
