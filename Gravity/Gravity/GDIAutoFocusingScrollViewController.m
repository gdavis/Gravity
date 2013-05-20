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

@interface GDIAutoFocusingScrollViewController () {
    BOOL _isRotating;
    CGPoint _originalOffset;
    CGFloat _animationDuration;
    UIView *_referenceView;
    __weak UIView *_currentView;
    __weak UIView *_tempView;
}

- (void)restoreContentScrollViewFrame;
- (void)scrollToView:(UIView *)subview animation:(BOOL)animate;

@end

@implementation GDIAutoFocusingScrollViewController
@synthesize contentScrollView;
@synthesize shouldResizeScrollViewWhenKeyboardIsPresent;

#pragma mark - UIViewController Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        shouldResizeScrollViewWhenKeyboardIsPresent = YES;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        shouldResizeScrollViewWhenKeyboardIsPresent = YES;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _animationDuration = .25f;
    
    // listen for keyboard events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidDock) name:UIKeyboardDidDockNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidUndock) name:UIKeyboardDidUndockNotification object:nil];
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidDockNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidUndockNotification object:nil];
    
    _referenceView = nil;
    [self setContentScrollView:nil];
    [super viewDidUnload];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // create a view with the same autosize properties as our scroll view.
    // this allows us to adjust the size of the scroll view frame while 
    // keyboard is showing and use this view as a reference as to how the 
    // scroll view's frame would have changed in response to rotations
    // if we weren't taking over the sizing of the scroll view.
    if (!_referenceView) {
        _referenceView = [[UIView alloc] initWithFrame:self.contentScrollView.frame];
        _referenceView.backgroundColor = [UIColor clearColor];
        _referenceView.autoresizingMask = self.contentScrollView.autoresizingMask;
        _referenceView.userInteractionEnabled = NO;
        [self.contentScrollView.superview insertSubview:_referenceView belowSubview:self.contentScrollView];
    }
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
    
    // resize our content scroll view for the rotation
    // when we finish, we can resize it again to position
    // once more on the current view, if there is one.
    self.contentScrollView.frame = _referenceView.frame;
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
    if (_currentView) {
        [self scrollToView:_currentView animation:YES];
    }
}


- (void)handleKeyboardDidUndock
{
    [self restoreContentScrollViewFrame];
    
    if (_currentView) {
        [self scrollToView:_currentView animation:YES];
    }
}


- (void)handleKeyboardDidShow:(NSNotification *)n
{
    if (_tempView) {
        [self scrollContentViewWithFocusOnSubview:_tempView animation:YES];
        _tempView = nil;
    }
}


- (void)handleKeyboardDidHide:(NSNotification *)n
{
    // if this value comes back as true, the user is moving between keyboard display
    // modes and is not actually hiding the keyboard.
    BOOL changedByUser = [[[n userInfo] objectForKey:@"UIKeyboardFrameChangedByUserInteraction"] boolValue];
    if (!changedByUser) {
        if (_currentView && !_isRotating) {
            [self restoreContentScrollViewFrame];
            _currentView = nil;
        }
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
    UIView *rootView = window.rootViewController.view;
    
    // calculate the viewable area with the keyboard all up in our grill
    // by first getting global frame positions for the subuview and scroll view
    CGRect globalSubviewFrame = [subview convertRect:subview.bounds toView:rootView];
    CGRect globalScrollViewFrame = [self.contentScrollView convertRect:self.contentScrollView.bounds toView:rootView];
    
    // get the viewable area for this orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect totalAvailableArea = [self viewableAreaForOrientation:orientation];
    
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
        [self.contentScrollView setContentOffset:finalOffset animated:animate];
    }
    
    // resize the content scroll view so the bottom of the frame only
    // goes as high as the top of the keyboard frame, if allowed
    if (self.shouldResizeScrollViewWhenKeyboardIsPresent) {
        if (animate) {
            [UIView animateWithDuration:_animationDuration ? _animationDuration : .25f 
                                  delay:0.f 
                                options:0  
                             animations:^{
                                 self.contentScrollView.frameHeight = viewableArea.size.height;
                             } completion:nil];
        }
        else {
            self.contentScrollView.frameHeight = viewableArea.size.height;
        }
    }
}


// returns a rect representing the area of the screen that is not taken
// up by the keyboard when it displays
// TODO: Abstract sizes for different interface idioms
- (CGRect)viewableAreaForOrientation:(UIInterfaceOrientation)orientation
{
    
    CGRect keyboardFrame = [[GDIKeyboardObserver sharedObserver] keyboardFrame];
    
    // user an empty frame if the keyboard is not docked while on ipad.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (![[GDIKeyboardObserver sharedObserver] isDocked]) {
            keyboardFrame = CGRectZero;
        }
    }
    
    CGRect windowSize = [[[[UIApplication sharedApplication] delegate] window] frame];
    CGRect viewableArea = CGRectZero;
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            viewableArea = CGRectMake(0, 0, windowSize.size.width, windowSize.size.height - keyboardFrame.size.height);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            viewableArea = CGRectMake(0, 0, windowSize.size.height, windowSize.size.width - keyboardFrame.size.height);
            break;
        }
        default:
            break;
    }
    return viewableArea;
}


- (void)restoreContentScrollViewFrame
{    
    // restore scroll frame
    self.contentScrollView.frame = _referenceView.frame;
}


@end
