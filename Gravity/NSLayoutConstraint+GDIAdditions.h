//
//  NSLayoutConstraint+GDIAdditions.h
//  Gravity
//
//  Created by Grant Davis on 4/30/15.
//  Copyright (c) 2015 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (GDIAdditions)

+ (NSArray *)constraintsToFillSuperviewWithView:(UIView *)view;
+ (NSArray *)constraintsToSizeView:(UIView *)view size:(CGSize)size;
+ (NSArray *)constraintsToSizeView:(UIView *)view size:(CGSize)size priority:(UILayoutPriority)priority;
+ (NSArray *)constraintsToCenterView:(UIView *)view inView:(UIView *)superView;

@end
