//
//  NSDate+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 4/7/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//



@interface NSDate (GDIAdditions)

+ (NSInteger)daysBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSInteger)daysFromDate:(NSDate *)date;

- (BOOL)isDateBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)dateWithDaysFromNow:(NSUInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSUInteger)days;
+ (NSDate *)dateWithMinutesFromNow:(NSUInteger)days;

@end
