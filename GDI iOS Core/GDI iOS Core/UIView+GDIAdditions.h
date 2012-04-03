//
//  UIView+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/15/12.
//  Copyright (c) 2012 rabble+rouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GDIAdditions)

/**
 * Frame access convenience methods
 */
@property (nonatomic) CGFloat frameLeft;
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;
@property (nonatomic) CGFloat frameTop;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGPoint frameOrigin;


/**
 * Removes all child subviews
*/
- (void)removeAllSubviews;

/**
 * @returns a UIImage of the view's current state
 */
- (UIImage*)imageOfView;

/**
 * @returns the first view within the specified nib. 
 */
+ (UIView *)viewFromNib:(NSString*)nibName;


@end