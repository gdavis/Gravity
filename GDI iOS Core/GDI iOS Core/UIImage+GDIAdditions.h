//
//  UIImage+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/9/12.
//  Copyright (c) 2012 rabble+rouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GDIAdditions)

- (UIImage *)imageWithTintColor:(UIColor *)color;
+ (UIImage*)imageOfView:(UIView*)view;
+ (UIImage*)imageFromMainBundleWithName:(NSString*)filename;

@end
