//
//  NSDate+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 4/7/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSDate+GDIAdditions.h"

@implementation NSDate (GDIAdditions)

+ (NSInteger)daysBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	NSInteger days = [components day];
	return days;
}

- (NSInteger)daysFromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:self
												  toDate:date options:0];
	NSInteger days = [components day];
	return days;
}

- (BOOL)isDateBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSTimeInterval dateInterval = [self timeIntervalSince1970];
    NSTimeInterval startInterval = [startDate timeIntervalSince1970];
    NSTimeInterval endInterval = [endDate timeIntervalSince1970];
    return dateInterval >= startInterval && dateInterval <= endInterval;
}


+ (NSDate *)dateWithDaysFromNow:(CGFloat)days
{
    return [NSDate dateWithHoursFromNow:24 * days];
}


+ (NSDate *)dateWithHoursFromNow:(CGFloat)hours 
{
    return [NSDate dateWithMinutesFromNow:60 * hours];
}


+ (NSDate *)dateWithMinutesFromNow:(CGFloat)minutes 
{
    return [NSDate dateWithTimeIntervalSinceNow:60 * minutes];
}


+ (NSDate *)dateWithDays:(CGFloat)days fromDate:(NSDate *)date
{
    return [NSDate dateWithHours:24 * days fromDate:date];
}

+ (NSDate *)dateWithHours:(CGFloat)hours fromDate:(NSDate *)date
{
    return [NSDate dateWithMinutes:60 * hours fromDate:date];
}

+ (NSDate *)dateWithMinutes:(CGFloat)mins fromDate:(NSDate *)date
{
    return [NSDate dateWithTimeInterval:60 * mins sinceDate:date];
}


@end
