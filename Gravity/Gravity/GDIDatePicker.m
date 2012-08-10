//
//  GDIDatePicker.m
//  Gravity
//
//  Created by Grant Davis on 8/10/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIDatePicker.h"
#import "UIView+GDIAdditions.h"
#import "NSDate+GDIAdditions.h"

#define kRowHeight 44.f
#define kSideMargin 27.f
#define kYearComponentWidth 78.f
#define kDayComponentWidth 50.f


@interface GDIDatePicker() {
    UITapGestureRecognizer *_tapGesture;
}

- (void)initPicker;

@end

@implementation GDIDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPicker];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initPicker];
    }
    return self;
}


- (void)initPicker
{
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:_tapGesture];
}


- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        // get the position of the touch
        CGPoint loc = [gesture locationInView:self];
        
        // we want to account for the side margins, so
        // we offset the location and then check inside a rect
        // created by subtracting the side margins to see
        // where the point exist inside our clickable area
        CGPoint offsetLoc = CGPointMake(loc.x - kSideMargin, loc.y);
        CGRect availableArea = CGRectMake(0, 0, self.frameWidth - kSideMargin * 2, self.frameHeight);
        
        // check to see if our available area contains the touch
        if (CGRectContainsPoint(availableArea, offsetLoc) && self.datePickerMode == UIDatePickerModeDate) {
            
            // determine which row the has been selected.
            NSUInteger rowIndex = floorf(offsetLoc.y / kRowHeight);
            NSUInteger middleRowIndex = floorf((availableArea.size.height * .5) / kRowHeight);
            NSInteger rowDelta = rowIndex - middleRowIndex;
            
            // create a calendar to base our date adjusts on
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            
            // create a date component object to modify the current
            // date based on where the user has touched
            NSDateComponents *components = [[NSDateComponents alloc] init];
            
            
            // determine which component has been selected
            if (offsetLoc.x >= availableArea.size.width - kYearComponentWidth) {
                // year touched
                // select the date +/- 1 year
                [components setYear:rowDelta];
                
            }
            else if (offsetLoc.x >= availableArea.size.width - kYearComponentWidth - kDayComponentWidth) {
                // day touched
                [components setDay:rowDelta];
            }
            else {
                // month touched
                [components setMonth:rowDelta];
            }
            
            NSDate *adjustedDate = [gregorian dateByAddingComponents:components toDate:self.date options:0];
            [self setDate:adjustedDate animated:YES];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}


@end
