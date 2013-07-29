//
//  BTTTaskDao.h
//  PersistIn100Days
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTTask.h"

@interface BTTTaskDao : NSObject

- (BOOL) save:(BTTTask *)task;

- (BOOL) update:(BTTTask *)task;

- (BOOL) del:(BTTTask *)task;

- (NSArray *)list:(int)offset size:(int)size;

- (NSArray *)listWithStatus:(NSNumber *)status offset:(int)offset size:(int)size;

- (BTTTask *)get:(NSNumber *)taskId;

- (BTTTask *)getCurrent;

- (BOOL) setCurrent:(NSNumber *)taskId;

@end
