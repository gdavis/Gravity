//
//  UISearchBar+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 3/19/12.
//  Copyright (c) 2012 rabble+rouser. All rights reserved.
//

#import "UISearchBar+GDIAdditions.h"

@implementation UISearchBar (GDIAdditions)

- (UITextField *)textField {
    // HACK: This may not work in future iOS versions
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UITextField class]]) {
            return (UITextField *)subview;
        }
    }
    return nil;
}

@end
