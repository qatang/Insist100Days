//
// Created by qatang on 13-8-27.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BTTTask.h"

@interface BTTStatisticsDetailCellView : UITableViewCell

@property (nonatomic) CGFloat height;

- (void)setTask:(BTTTask *)taskParam currentDays: (NSInteger)currentDaysParam;

@end