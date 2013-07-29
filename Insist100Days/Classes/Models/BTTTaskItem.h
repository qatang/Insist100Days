//
//  BTTTaskItem.h
//  PersistIn100Days
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTTaskItem : NSObject

@property (strong, nonatomic) NSNumber *itemId;
@property (strong, nonatomic) NSNumber *taskId;
@property (strong, nonatomic) NSString *memo;
@property (strong, nonatomic) NSNumber *checked;//0,未签 1,已签
@property (strong, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NSDate *updatedTime;
@property (strong, nonatomic) NSNumber *currentDays;

@end
