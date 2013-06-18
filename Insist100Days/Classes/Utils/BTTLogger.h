//
//  BTTLogger.h
//  AA
//
//  Created by Sunshow on 13-2-17.
//  Copyright (c) 2013年 BlueTiger. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#import "LoggerClient.h"

#ifdef LOGGER_NSLOG_OVERRIDE
#define NSLog(format, ...) do { \
    LogMessageF(__FILE__, __LINE__, __PRETTY_FUNCTION__, @"<Console>", 0, \
    format, ##__VA_ARGS__); \
    } while(0)
#endif

#define BTTLOG_DEBUG(format, ...) do { \
    LogMessageF(__FILE__, __LINE__, __PRETTY_FUNCTION__, @"<DEBUG>", 1, format, ##__VA_ARGS__); \
    NSLog((@"<DEBUG>: %s #%d %s" format), __FILE__, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__); \
    } while(0)

#define BTTLOG_INFO(format, ...) do { \
    LogMessageF(__FILE__, __LINE__, __PRETTY_FUNCTION__, @"<INFO>", 2, format, ##__VA_ARGS__); \
    NSLog((@"<INFO>: %s #%d %s" format), __FILE__, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__); \
    } while(0)

#define BTTLOG_WARN(format, ...) do { \
    LogMessageF(__FILE__, __LINE__, __PRETTY_FUNCTION__, @"<WARN>", 3, format, ##__VA_ARGS__); \
    NSLog((@"<WARN>: %s #%d %s" format), __FILE__, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__); \
    } while(0)

#define BTTLOG_ERROR(format, ...) do { \
    LogMessageF(__FILE__, __LINE__, __PRETTY_FUNCTION__, @"<ERROR>", 4, format, ##__VA_ARGS__); \
    NSLog((@"<ERROR>: %s #%d %s" format), __FILE__, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__); \
    } while(0)

#else

#define BTTLOG_DEBUG(...)    do{}while(0)
#define BTTLOG_INFO BTTLOG_DEBUG
#define BTTLOG_WARN BTTLOG_DEBUG
#define BTTLOG_ERROR BTTLOG_DEBUG

#endif
