//
//  GDITouchProxyViewView.h
//  GDI iOS Core
//
//  Created by Grant Davis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDITouchProxyViewDelegate;

@interface GDITouchProxyView : UIView

@property(strong,nonatomic) NSObject<GDITouchProxyViewDelegate> *delegate;

@end


@protocol GDITouchProxyViewDelegate
@optional
- (void)gestureView:(GDITouchProxyView *)gv touchBeganAtPoint:(CGPoint)point;
- (void)gestureView:(GDITouchProxyView *)gv touchMovedToPoint:(CGPoint)point;
- (void)gestureView:(GDITouchProxyView *)gv touchEndedAtPoint:(CGPoint)point;
@end