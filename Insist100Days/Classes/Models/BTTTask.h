//
//  BTTTask.h
//  PersistIn100Days
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTTask : NSObject

@property (strong, nonatomic) NSNumber *taskId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NSDate *updatedTime;
@property (strong, nonatomic) NSDate *beginTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSNumber *status;//0,未开始 1,进行中 2,已结束
@property (strong, nonatomic) NSNumber *current;//0,不是当前任务 1,是当前任务
@property (strong, nonatomic) NSNumber *checkedDays;//已签天数
@property (strong, nonatomic) NSNumber *totalDays;//总共天数

@end
