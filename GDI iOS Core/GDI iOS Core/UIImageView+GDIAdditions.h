//
//  UIImageView+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 5/21/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GDIAdditions)

- (void)setImageInBackgroundThreadWithName:(NSString *)imageName;
- (void)setImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath;

@end
