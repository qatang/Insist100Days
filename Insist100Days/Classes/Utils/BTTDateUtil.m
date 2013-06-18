//
//  BTTDateUtil.m
//  FirstTry
//
//  Created by qatang on 13-3-1.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import "BTTDateUtil.h"
#define BTT_DATE_DEFAULT_PATTERN @"yyyy-MM-dd"
#define BTT_DATE_LONG_PATTERN @"yyyy-MM-dd HH:mm:ss"

@implementation BTTDateUtil

+ (NSDateFormatter *)getDateFormatter:(NSString *)pattern {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:pattern];
    return formatter;
}

+ (NSString *)convertDateToDateStringByDefaultPattern:(NSDate *)date {
    return [BTTDateUtil convertDateToDateStringByAnyPattern:date byPattern:BTT_DATE_DEFAULT_PATTERN];
}

+ (NSString *)convertDateToDateStringByLongPattern:(NSDate *)date {
    return [BTTDateUtil convertDateToDateStringByAnyPattern:date byPattern:BTT_DATE_LONG_PATTERN];
}

+ (NSString *)convertDateToDateStringByAnyPattern:(NSDate *)date byPattern:(NSString *)pattern {
    NSDateFormatter *formatter = [BTTDateUtil getDateFormatter:pattern];
    return [formatter stringFromDate:date];
}

+ (NSString *)convertTimestampToDateStringByDefaultPattern:(NSNumber *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return [BTTDateUtil convertDateToDateStringByDefaultPattern:date];
}

+ (NSString *)convertTimestampToDateStringByLongPattern:(NSNumber *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return [BTTDateUtil convertDateToDateStringByLongPattern:date];
}

+ (NSString *)convertTimestampToDateStringByAnyPattern:(NSNumber *)timestamp byPattern:(NSString *)pattern {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return [BTTDateUtil convertDateToDateStringByAnyPattern:date byPattern:pattern];
}

+ (NSString *)weekdayByChinesePattern:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:date];

    NSInteger weekday = [weekdayComponents weekday];
    switch (weekday) {
        case 1:
            return @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return nil;
    }
}

//从公元元年开始计算天数，相减之后得到两个日期之间的天数
+ (NSInteger)daysBetweenTwoDatesByEra:(NSDate *) startDate toDate:(NSDate *) endDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger startDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[gregorian ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:endDate];
    return endDay-startDay;
}

@end
