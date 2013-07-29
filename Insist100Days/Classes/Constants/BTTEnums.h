//
// Created by qatang on 13-6-19.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

//是否
typedef NS_ENUM(NSUInteger, bookStatus)
{
    BTT_NO,
    BTT_YES
};

//任务状态枚举
typedef NS_ENUM(NSUInteger, TaskStatus)
{
    BTT_TASK_INITIALIZED,//未开始
    BTT_TASK_DOING,//进行中
    BTT_TASK_DONE//已结束
};
