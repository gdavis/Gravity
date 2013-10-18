//
//  GDIKeyboardObserver.m
//  Gravity
//
//  Created by Grant Davis on 11/19/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIKeyboardObserver.h"

@implementation GDIKeyboardObserver

NSString * const GDIKeyboardDidDockNotification = @"GDIKeyboardDidDockNotification";
NSString * const GDIKeyboardDidUndockNotification = @"GDIKeyboardDidUndockNotification";

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardFrameChange:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)handleKeyboardFrameChange:(NSNotification *)n
{
    CGRect keyboardFrame = [[[n userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
//    NSLog(@"****");
//    NSLog(@"keyboard changed to: %@", NSStringFromCGRect(_keyboardFrame));
//    NSLog(@"window bounds: %@", NSStringFromCGRect([window bounds]));
//    NSLog(@"root view bounds: %@", NSStringFromCGRect(rootView.bounds));
    
    _keyboardFrame = [rootView convertRect:keyboardFrame fromView:window];
//    NSLog(@"relative keyboard bounds: %@", NSStringFromCGRect(_keyboardFrame));
    
    // first check to see if the keyboard intersects the main window.
    // if it does, we know the keyboard is visible and we can detect is position
    if (CGRectIntersectsRect(rootView.bounds, _keyboardFrame)) {
        
        _isVisible = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            CGFloat dockedHeight = UIInterfaceOrientationIsPortrait(orientation) ? 264.f : 352.f;
            CGFloat screenHeight = UIInterfaceOrientationIsPortrait(orientation) ? 1024.f : 768.f;
            
            _isFitToBottom = _keyboardFrame.origin.y + _keyboardFrame.size.height == screenHeight;
            
            if (_isFitToBottom &&
                (_keyboardFrame.size.width == dockedHeight || _keyboardFrame.size.height == dockedHeight)) {
                
                // Keyboard is docked
                _isDocked = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidDockNotification object:nil];
            } else {
                // Keyboard is split or undocked
                _isDocked = NO;
                [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidUndockNotification object:nil];
            }
        }
        else {
            _isFitToBottom = YES;
            _isDocked = NO;
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
