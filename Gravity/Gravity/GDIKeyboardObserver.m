//
//  GDIKeyboardObserver.m
//  Gravity
//
//  Created by Grant Davis on 11/19/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIKeyboardObserver.h"

@implementation GDIKeyboardObserver

NSString * const UIKeyboardDidDockNotification = @"GDIKeyboardDidDockNotification";
NSString * const UIKeyboardDidUndockNotification = @"GDIKeyboardDidUndockNotification";

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardFrameChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleKeyboardFrameChange:(NSNotification *)n
{
    _keyboardFrame = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"keyboard changed to: %@", NSStringFromCGRect(_keyboardFrame));
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect windowFrame = [window bounds];
    
    // first check to see if the keyboard intersects the main window.
    // if it does, we know the keyboard is visible and we can detect is position
    if (CGRectIntersectsRect(windowFrame, _keyboardFrame)) {
        
        _isVisible = YES;
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        CGFloat dockedHeight = UIInterfaceOrientationIsPortrait(orientation) ? 264.f : 352.f;
        CGFloat screenHeight = UIInterfaceOrientationIsPortrait(orientation) ? 1024.f : 768.f;
        
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            _isFitToBottom = _keyboardFrame.origin.y + _keyboardFrame.size.height == screenHeight;
        }
        else {
            _isFitToBottom = _keyboardFrame.origin.x + _keyboardFrame.size.width == screenHeight;
        }
        
        if (_isFitToBottom &&
            (_keyboardFrame.size.width == dockedHeight || _keyboardFrame.size.height == dockedHeight)) {
            
            if (!_isDocked) {
                // Keyboard is docked
                _isDocked = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidDockNotification object:nil];
            }
        } else if (_isDocked) {
            // Keyboard is split or undocked
            _isDocked = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidUndockNotification object:nil];
        }
    }
    else _isVisible = NO;
}


+ (GDIKeyboardObserver *)sharedObserver
{
    static dispatch_once_t onceToken;
    static GDIKeyboardObserver *keyboardObs;
    dispatch_once(&onceToken, ^{
        keyboardObs = [[GDIKeyboardObserver alloc] init];
    });
    return keyboardObs;
}

@end
