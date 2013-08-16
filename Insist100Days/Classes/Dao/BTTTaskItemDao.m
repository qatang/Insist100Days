//
//  BTTTaskItemDao.m
//  PersistIn100Days
//
//  Created by qatang on 13-3-19.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import "BTTTaskItemDao.h"
#import "BTTDatabaseUtil.h"

@interface BTTTaskItemDao()

@property (strong, nonatomic) FMDatabase *db;

- (BTTTaskItem *) convertFromRs:(FMResultSet *)rs;

@end

@implementation BTTTaskItemDao

@synthesize db;

- (id)init {
    self = [super init];
    if (self) {
        db = [[BTTDatabaseUtil shared] db];
    }

    return self;
}

- (BTTTaskItem *) convertFromRs:(FMResultSet *)rs {
    BTTTaskItem *taskItem = [[BTTTaskItem alloc] init];
    
    taskItem.itemId = [rs objectForColumnName:@"item_id"];
    taskItem.taskId = [rs objectForColumnName:@"task_id"];
    taskItem.memo = [rs stringForColumn:@"memo"];
    taskItem.createdTime = [NSDate dateWithTimeIntervalSince1970:[[rs objectForColumnName:@"created_time"] doubleValue]];
    taskItem.updatedTime = [NSDate dateWithTimeIntervalSince1970:[[rs objectForColumnName:@"updated_time"] doubleValue]];
    taskItem.checked = [rs objectForColumnName:@"checked"];
    taskItem.currentDays = [rs objectForColumnName:@"current_days"];
    
    return taskItem;
}

- (BOOL)save:(BTTTaskItem *)taskItem {
    BOOL result;
    [self.db beginTransaction];
    NSNumber *createdTime = [NSNumber numberWithLong:[taskItem.createdTime timeIntervalSince1970]];
    NSNumber *updatedTime = [NSNumber numberWithLong:[taskItem.updatedTime timeIntervalSince1970]];
    result = [self.db executeUpdate:@"INSERT INTO btt_task_item(item_id, task_id, memo, created_time, updated_time, checked, current_days) VALUES (NULL, ?, ?, ?, ?, ?, ?)", taskItem.taskId, taskItem.memo , createdTime, updatedTime,taskItem.checked, taskItem.currentDays];
    if (result) {
        [self.db commit];
    } else {
        [self.db rollback];
    }
    return result;
}

- (BOOL)update:(BTTTaskItem *)taskItem {
    BOOL result;
    [self.db beginTransaction];
    NSNumber *updatedTime = [NSNumber numberWithLong:[taskItem.updatedTime timeIntervalSince1970]];
    result = [self.db executeUpdate:@"UPDATE btt_task_item SET memo=?, updated_time=?, checked=?, current_days=? WHERE item_id=?", taskItem.memo, updatedTime, taskItem.checked, taskItem.currentDays, taskItem.itemId];
    if (result) {
        [self.db commit];
    } else {
        [self.db rollback];
    }
    return result;
}

- (NSArray *)list:(NSNumber *)taskId offset:(int)offset size:(int)size {
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task_item WHERE task_id=? ORDER BY created_time DESC LIMIT ?, ?", taskId, [NSNumber numberWithInt:offset], [NSNumber numberWithInt:size]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([rs next]) {
        BTTTaskItem *taskItem = [self convertFromRs:rs];
        [array addObject:taskItem];
    }
    [rs close];
    return array;
}

- (BTTTaskItem *)get:(NSNumber *)taskItemId {
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task_item WHERE item_id=?", taskItemId];
    BTTTaskItem *taskItem = nil;
    while ([rs next]) {
        taskItem = [self convertFromRs:rs];
    }
    [rs close];
    return taskItem;
}

- (BTTTaskItem *)get:(NSNumber *)taskId currentDays:(NSNumber *)currentDays {
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task_item WHERE task_id=? AND current_days=?", taskId, currentDays];
    BTTTaskItem *taskItem = nil;
    while ([rs next]) {
        taskItem = [self convertFromRs:rs];
    }
    [rs close];
    return taskItem;
}

@end
