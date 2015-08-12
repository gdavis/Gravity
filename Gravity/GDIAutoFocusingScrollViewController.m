//
//  GDIAutoFocusingScrollViewController.m
//  Gravity
//
//  Created by Grant Davis on 6/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIAutoFocusingScrollViewController.h"
#import "UIView+GDIAdditions.h"
#import "GDIKeyboardObserver.h"
#import "NSObject+PerformBlockAfterDelay.h"
#import "UIDevice+GDIAdditions.h"

@interface GDIAutoFocusingScrollViewController () {
    BOOL _isRotating;
    CGPoint _originalOffset;
    UIEdgeInsets _originalContentInset;
    UIEdgeInsets _originalScrollInset;
    CGFloat _animationDuration;
    UIView *_currentView;
    UIView *_tempView;
}

@end


@implementation GDIAutoFocusingScrollViewController

#pragma mark - UIViewController Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    // ensure the keyboard observer is listening for events
    [GDIKeyboardObserver sharedObserver];
    
    // set defaults
    _shouldResizeScrollViewWhenKeyboardIsPresent = YES;
    _animationDuration = .25f;
    _originalContentInset = UIEdgeInsetsZero;
    _originalScrollInset = UIEdgeInsetsZero;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // listen for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidDock) name:GDIKeyboardDidDockNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidUndock) name:GDIKeyboardDidUndockNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}


#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    _isRotating = YES;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    _isRotating = NO;
    
    if (_currentView) {
        _originalOffset = CGPointZero;
        [self scrollToView:_currentView animation:NO];
    }
}


#pragma mark - Keyboard Notification Handlers

- (void)handleKeyboardDidDock
{
    [self scrollToCurrentView];
}


- (void)handleKeyboardDidUndock
{
    [self restoreContentScrollViewInsets];
    
    [self scrollToCurrentView];
}


- (void)handleKeyboardWillShow:(NSNotification *)n
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf scrollToTempView];
    });
}


- (void)handleKeyboardDidShow:(NSNotification *)n
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf adjustTableContentInsetsWithAnimation:YES];
        [weakSelf scrollToTempView];
    });
}


- (void)scrollToTempView
{
    if (_tempView != nil) {
        [self scrollContentViewWithFocusOnSubview:_tempView animation:YES];
        _tempView = nil;
    }
}


- (void)scrollToCurrentView
{
    if (_currentView) {
        [self scrollToView:_currentView animation:YES];
    }
}


- (void)handleKeyboardDidHide:(NSNotification *)n
{
    // if this value comes back as true, the user is moving between keyboard display
    // modes and is not actually hiding the keyboard.
    BOOL changedByUser = [[[n userInfo] objectForKey:@"UIKeyboardFrameChangedByUserInteraction"] boolValue];
    if (!changedByUser) {
        if (_currentView && !_isRotating) {
            [self restoreContentScrollViewInsets];
            _currentView = nil;
        }
    }
}


- (void)handleKeyboardWillHide:(NSNotification *)n
{
    // resize the content scroll view so the bottom of the frame only
    // goes as high as the top of the keyboard frame, if allowed
    __weak typeof(self) weakSelf = self;
    NSInteger animationCurve = [[n.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat animationDuration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (self.shouldResizeScrollViewWhenKeyboardIsPresent) {
        [UIView animateWithDuration:animationDuration
                              delay:0.f
                            options:animationCurve
                         animations:^{
                             [weakSelf restoreContentScrollViewInsets];
                         } completion:nil];
    }
    
    if (CGPointEqualToPoint(self.contentScrollView.contentOffset, _originalOffset) == NO) {
        [UIView animateWithDuration:animationDuration ? animationDuration : .25f
                              delay:0.f
                            options:animationCurve
                         animations:^{
                             weakSelf.contentScrollView.contentOffset = _originalOffset;
                         } completion:nil];
    }
}


#pragma mark - Public Methods

- (void)scrollContentViewWithFocusOnSubview:(UIView *)subview animation:(BOOL)animate
{
    UIView *prevView = _currentView;
    
    if (![[GDIKeyboardObserver sharedObserver] isVisible]) {
        _tempView = subview;
        return;
    }
    
    // store reference
    _currentView = subview;
    
    // store the original scrollview offset if this is the first
    // time we are adjusting the scroll view.
    if (prevView == nil) {
        _originalOffset = self.contentScrollView.contentOffset;
        _originalContentInset = self.contentScrollView.contentInset;
        _originalScrollInset = self.contentScrollView.scrollIndicatorInsets;
    }
    
    // do the scroll
    [self scrollToView:subview animation:animate];
}


#pragma mark - Private Methods

- (void)scrollToView:(UIView *)subview animation:(BOOL)animate
{
    // store current offset
    CGPoint currentOffset = self.contentScrollView.contentOffset;
    
    // store reference to our level view to determine global coordinates
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    // get the viewable area for this orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect totalAvailableArea = [self viewableAreaForOrientation:orientation];
    
    // calculate the viewable area with the keyboard all up in our grill
    // by first getting global frame positions for the subuview and scroll view
    CGRect globalSubviewFrame = [subview convertRect:subview.bounds toView:window];
    CGRect globalScrollViewFrame = [self.contentScrollView convertRect:self.contentScrollView.bounds toView:window];
    
    // determine the viewable area by taking the total available area
    // and the global rect of the subview to see if its currently in view.
    CGRect viewableArea = CGRectIntersection(totalAvailableArea, globalScrollViewFrame);
    
    // if the relative rect is not within our viewable area,
    // then we can continue repositioning the scroll view.
    if (!CGRectContainsRect(viewableArea, globalSubviewFrame)) {
        
        // find the target y position for the field. we check whether
        // its closer to the top or bottom of the scroll view, then
        // position it to whichever edge is closest.
        CGFloat targetY;
        // check if the frame is above or below the mid point
        if (CGRectGetMidY(viewableArea) - CGRectGetMidY(globalSubviewFrame) > 0) {
            // field is above
            targetY = CGRectGetMinY(viewableArea) + globalSubviewFrame.size.height * .5;
        }
        else {
            // field is below
            targetY = CGRectGetMaxY(viewableArea) - globalSubviewFrame.size.height * .5;
        }
        
        // get the position of the field if it were centered in the viewable area
        CGFloat yp = targetY - globalSubviewFrame.size.height * .5;
        
        // determine distance between the target y and our actual
        CGFloat dy = yp - globalSubviewFrame.origin.y;
        
        // create a new point that moves the distance to our target y
        CGPoint finalOffset = CGPointMake(0, currentOffset.y - dy);
        
        // set new offset
        if (animate) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:_animationDuration ? _animationDuration : .25f
                                  delay:0.f
                                options:0
                             animations:^{
                                 weakSelf.contentScrollView.contentOffset = finalOffset;
                             } completion:nil];
        }
        else {
            self.contentScrollView.contentOffset = finalOffset;
        }
    }
    
    // resize the content scroll view so the bottom of the frame only
    // goes as high as the top of the keyboard frame, if allowed
    if (self.shouldResizeScrollViewWhenKeyboardIsPresent) {
        [self adjustTableContentInsetsWithAnimation:animate];
    }
}

// returns a rect representing the area of the screen that is not taken
// up by the keyboard when it displays
- (CGRect)viewableAreaForOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat statusBarHeight;
    if ([UIDevice isOS7OrLater] || [UIApplication sharedApplication].statusBarHidden) {
        statusBarHeight = 0.f;
    }
    else {
        statusBarHeight = 20.f;
    }
    CGRect keyboardFrame = [[GDIKeyboardObserver sharedObserver] keyboardFrame];
    
    // user an empty frame if the keyboard is not docked while on ipad.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
        && ![[GDIKeyboardObserver sharedObserver] isDocked]) {
        keyboardFrame = CGRectZero;
    }
    
    CGRect windowSize = [[[[UIApplication sharedApplication] delegate] window] frame];
    CGRect viewableArea = CGRectZero;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            viewableArea = CGRectMake(0,
                                      statusBarHeight,
                                      windowSize.size.width,
                                      windowSize.size.height - keyboardFrame.size.height - statusBarHeight);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            viewableArea = CGRectMake(0,
                                      statusBarHeight,
                                      windowSize.size.height,
                                      windowSize.size.width - keyboardFrame.size.height - statusBarHeight);
            break;
        }
        default:
            break;
    }
    return viewableArea;
}


- (void)adjustTableContentInsetsWithAnimation:(BOOL)animate
{
    if (!self.shouldResizeScrollViewWhenKeyboardIsPresent) {
        return;
    }
    
    // store reference to our level view to determine global coordinates
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect globalScrollViewFrame = [self.contentScrollView convertRect:self.contentScrollView.bounds toView:window];
    
    CGRect globalKeyboardFrame = [[GDIKeyboardObserver sharedObserver] keyboardFrame];
    CGRect keyboardOverlapRect = CGRectIntersection(globalScrollViewFrame, globalKeyboardFrame);
    UIEdgeInsets insets = _originalContentInset;
    insets.bottom += CGRectGetHeight(keyboardOverlapRect);
    
    if (animate) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:_animationDuration ? _animationDuration : .25f
                              delay:0.f
                            options:0
                         animations:^{
                             weakSelf.contentScrollView.contentInset = insets;
                             weakSelf.contentScrollView.scrollIndicatorInsets = insets;
                         } completion:nil];
    }
    else {
        self.contentScrollView.contentInset = insets;
        self.contentScrollView.scrollIndicatorInsets = insets;
    }
}


- (void)restoreContentScrollViewInsets
{
    if (self.shouldResizeScrollViewWhenKeyboardIsPresent) {
        self.contentScrollView.contentInset = _originalContentInset;
        self.contentScrollView.scrollIndicatorInsets = _originalScrollInset;
    }
}

@end
