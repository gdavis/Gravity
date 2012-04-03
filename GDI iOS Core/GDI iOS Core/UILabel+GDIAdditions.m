//
//  UILabel+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/23/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UILabel+GDIAdditions.h"

@implementation UILabel (GDIAdditions)

- (void)adjustHeightToFitText
{
    if (!self.text || [self.text length] == 0 || self.numberOfLines > 0) {
        return;
    }
    
    CGSize labelSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, FLT_MAX) lineBreakMode:self.lineBreakMode];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, labelSize.height);
}

@end
