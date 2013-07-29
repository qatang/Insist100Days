//
//  BTTTaskItemDao.h
//  PersistIn100Days
//
//  Created by qatang on 13-3-19.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTTaskItem.h"

@interface BTTTaskItemDao : NSObject

- (BOOL) save:(BTTTaskItem *)taskItem;

- (BOOL) update:(BTTTaskItem *)taskItem;

- (NSArray *)list:(NSNumber *)taskId offset:(int)offset size:(int)size;

- (BTTTaskItem *)get:(NSNumber *)taskItemId;

- (BTTTaskItem *)get:(NSNumber *)taskId currentDays:(NSNumber *)currentDays;

@end
