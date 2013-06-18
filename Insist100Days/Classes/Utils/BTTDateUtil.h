//
//  BTTDateUtil.h
//  FirstTry
//
//  Created by qatang on 13-3-1.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTDateUtil : NSObject

+ (NSString *)convertDateToDateStringByDefaultPattern:(NSDate *)date;

+ (NSString *)convertDateToDateStringByLongPattern:(NSDate *)date;

+ (NSString *)convertDateToDateStringByAnyPattern:(NSDate *)date byPattern:(NSString *)pattern;

+ (NSString *)convertTimestampToDateStringByDefaultPattern:(NSNumber *)timestamp;

+ (NSString *)convertTimestampToDateStringByLongPattern:(NSNumber *)timestamp;

+ (NSString *)convertTimestampToDateStringByAnyPattern:(NSNumber *)timestamp byPattern:(NSString *)pattern;

+ (NSString *)weekdayByChinesePattern:(NSDate *)date;

+ (NSInteger)daysBetweenTwoDatesByEra:(NSDate *)startDate toDate:(NSDate *)endDate;

@end
