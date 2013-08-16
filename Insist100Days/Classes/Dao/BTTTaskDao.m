//
//  BTTTaskDao.m
//  PersistIn100Days
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import "BTTTaskDao.h"
#import "BTTDatabaseUtil.h"
#import "BTTEnums.h"

@interface BTTTaskDao()

@property (strong, nonatomic) FMDatabase *db;

- (BTTTask *) convertFromRs:(FMResultSet *)rs;

@end

@implementation BTTTaskDao

@synthesize db;

- (id)init {
    self = [super init];
    if (self) {
        db = [[BTTDatabaseUtil shared] db];
    }

    return self;
}

- (BTTTask *) convertFromRs:(FMResultSet *)rs {
    BTTTask *task = [[BTTTask alloc] init];
    
    task.taskId = [rs objectForColumnName:@"task_id"];
    task.title = [rs stringForColumn:@"title"];
    task.description = [rs stringForColumn:@"description"];
    task.createdTime = [NSDate dateWithTimeIntervalSince1970:[[rs objectForColumnName:@"created_time"] doubleValue]];
    task.updatedTime = [NSDate dateWithTimeIntervalSince1970:[[rs objectForColumnName:@"updated_time"] doubleValue]];
    task.beginTime = [NSDate dateWithTimeIntervalSince1970:[[rs objectForColumnName:@"begin_time"] doubleValue]];
    task.endTime = [NSDate dateWithTimeIntervalSince1970:[[rs objectForColumnName:@"end_time"] doubleValue]];
    task.status = [rs objectForColumnName:@"status"];
    task.current = [rs objectForColumnName:@"current"];
    task.checkedDays = [rs objectForColumnName:@"checked_days"];
    task.totalDays = [rs objectForColumnName:@"total_days"];
    
    return task;
}

- (BOOL)save:(BTTTask *)task {    
    BOOL result;
    [self.db beginTransaction];
    
    NSNumber *createdTime = [NSNumber numberWithLong:[task.createdTime timeIntervalSince1970]];
    NSNumber *updatedTime = [NSNumber numberWithLong:[task.updatedTime timeIntervalSince1970]];
    NSNumber *beginTime = [NSNumber numberWithLong:[task.beginTime timeIntervalSince1970]];
    NSNumber *endTime = [NSNumber numberWithLong:[task.endTime timeIntervalSince1970]];

    result = [self.db executeUpdate:@"INSERT INTO btt_task(task_id, title, description, created_time, updated_time, begin_time, end_time, status, current, checked_days, total_days) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", task.title, task.description, createdTime, updatedTime, beginTime, endTime, task.status, task.current, task.checkedDays, task.totalDays];
    if (result) {
        [self.db commit];
    } else {
        [self.db rollback];
    }
    return result;
}

- (BOOL)update:(BTTTask *)task {
    BOOL result;
    [self.db beginTransaction];
    NSNumber *updatedTime = [NSNumber numberWithLong:[task.updatedTime timeIntervalSince1970]];
    result = [self.db executeUpdate:@"UPDATE btt_task SET title=?, description=?, updated_time=?, status=?, current=?, checked_days=?, total_days=? WHERE task_id=?", task.title, task.description, updatedTime, task.status, task.current, task.checkedDays, task.totalDays, task.taskId];
    if (result) {
        [self.db commit];
    } else {
        [self.db rollback];
    }
    return result;
}

- (BOOL)del:(BTTTask *)task {
    BOOL result;
    [self.db beginTransaction];
    BOOL taskResult = [self.db executeUpdate:@"DELETE FROM btt_task WHERE task_id=?", task.taskId];
    BOOL taskItemResult = [self.db executeUpdate:@"DELETE FROM btt_task_item WHERE task_id=?", task.taskId];
    
    if (taskResult && taskItemResult) {
        result = YES;
        [self.db commit];
    } else {
        result = NO;
        [self.db rollback];
    }
    return result;
}

- (NSArray *)list:(int)offset size:(int)size {
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task ORDER BY created_time DESC LIMIT ?, ?", [NSNumber numberWithInt:offset], [NSNumber numberWithInt:size]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([rs next]) {
        BTTTask *task = [self convertFromRs:rs];
        [array addObject:task];
    }
    [rs close];
    return array;
}

- (NSArray *)listWithStatus:(NSNumber *)status offset:(int)offset size:(int)size {
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task WHERE status=? ORDER BY created_time DESC LIMIT ?, ?", status, [NSNumber numberWithInt:offset], [NSNumber numberWithInt:size]];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    while ([rs next]) {
        BTTTask *task = [self convertFromRs:rs];
        [array addObject:task];
    }
    [rs close];
    return array;
}

- (BTTTask *)get:(NSNumber *)taskId {
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task WHERE task_id=?", taskId];
    BTTTask *task = nil;
    while ([rs next]) {
        task = [self convertFromRs:rs];
    }
    [rs close];
    return task;
}

- (BTTTask *)getCurrent{
    FMResultSet *rs = [self.db executeQuery:@"SELECT * FROM btt_task WHERE current=?", [NSNumber numberWithInteger:BTT_YES]];
    BTTTask *task = nil;
    while ([rs next]) {
        task = [self convertFromRs:rs];
    }
    [rs close];
    return task;
}

- (BOOL)setCurrent:(NSNumber *)taskId {
    BOOL result;
    BOOL resetResult;
    BOOL setResult;

    [self.db beginTransaction];

    resetResult = [self.db executeUpdate:@"UPDATE btt_task SET current=0 WHERE current=1"];
    setResult = [self.db executeUpdate:@"UPDATE btt_task SET current=1 WHERE task_id=?", taskId];
    if (resetResult && setResult) {
        result = YES;
        [self.db commit];
    } else {
        result = NO;
        [self.db rollback];
    }
    return result;
}

@end
