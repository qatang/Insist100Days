//
//  BTTConfig.h
//  AA
//
//  Created by qatang on 13-3-18.
//  Copyright (c) 2013年 qatang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BTT_DB_SCHEMA_VERSION 1
#define BTT_DB_FILENAME @"btt_insist100days.db"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#define DB_LIST_DEFAULT_MAX_PAGE_SIZE 1000

#define BTT_INSIST_DAYS_COUNT 100
#define PER_DAY_INTERVAL 24 * 60 * 60
#define WEEK_DAYS_COUNT 7

#define KEY_HAS_CREATED_TASK @"has_created_task"
