//
// Created by qatang on 13-8-7.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, weekDays)
{
    SUNDAY,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
};

@interface BTTWeekView : UIView

@property (strong, nonatomic) NSArray *weekTaskItemArray;

@end