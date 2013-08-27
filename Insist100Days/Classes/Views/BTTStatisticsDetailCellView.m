//
// Created by qatang on 13-8-27.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTStatisticsDetailCellView.h"
#import "BTTConfig.h"
#import "BTTEnums.h"

@interface BTTStatisticsDetailCellView()

@property (strong, nonatomic) BTTTask *task;
@property (nonatomic) NSInteger currentDays;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *taskStatusLabel;
@property (strong, nonatomic) UILabel *totalDaysStringLabel;
@property (strong, nonatomic) UILabel *totalDaysLabel;
@property (strong, nonatomic) UILabel *currentDaysStringLabel;
@property (strong, nonatomic) UILabel *currentDaysLabel;
@property (strong, nonatomic) UILabel *checkedDaysStringLabel;
@property (strong, nonatomic) UILabel *checkedDaysLabel;
@property (strong, nonatomic) UILabel *uncheckedDaysStringLabel;
@property (strong, nonatomic) UILabel *uncheckedDaysLabel;

@end

@implementation BTTStatisticsDetailCellView
@synthesize height;
@synthesize task;
@synthesize currentDays;
@synthesize mainView;
@synthesize titleLabel;
@synthesize taskStatusLabel;
@synthesize totalDaysLabel;
@synthesize totalDaysStringLabel;
@synthesize currentDaysStringLabel;
@synthesize currentDaysLabel;
@synthesize checkedDaysStringLabel;
@synthesize checkedDaysLabel;
@synthesize uncheckedDaysStringLabel;
@synthesize uncheckedDaysLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 初始化view
        [self initContentView];

    }
    return self;
}


-(void)initContentView{
    mainView = [[UIView alloc] init];

    titleLabel = [[UILabel alloc] init];
    taskStatusLabel = [[UILabel alloc] init];
    totalDaysStringLabel = [[UILabel alloc] init];
    totalDaysLabel = [[UILabel alloc] init];
    currentDaysStringLabel = [[UILabel alloc] init];
    currentDaysLabel = [[UILabel alloc] init];
    checkedDaysStringLabel = [[UILabel alloc] init];
    checkedDaysLabel = [[UILabel alloc] init];
    uncheckedDaysStringLabel = [[UILabel alloc] init];
    uncheckedDaysLabel = [[UILabel alloc] init];

    [mainView addSubview:titleLabel];
    [mainView addSubview:taskStatusLabel];
    [mainView addSubview:totalDaysStringLabel];
    [mainView addSubview:totalDaysLabel];
    [mainView addSubview:currentDaysStringLabel];
    [mainView addSubview:currentDaysLabel];
    [mainView addSubview:checkedDaysStringLabel];
    [mainView addSubview:checkedDaysLabel];
    [mainView addSubview:uncheckedDaysStringLabel];
    [mainView addSubview:uncheckedDaysLabel];

    [self addSubview:mainView];
}

- (void)layoutContentView{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);

    mainView.frame = self.bounds;

    titleLabel.frame = CGRectMake(10, 2, 80, 36);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text = task.title;

    taskStatusLabel.frame = CGRectMake(10, 42, 80, 16);
    taskStatusLabel.textAlignment = NSTextAlignmentLeft;
    taskStatusLabel.font = [UIFont systemFontOfSize:12];
    if (task.status.intValue == BTT_TASK_DOING) {
        taskStatusLabel.text = NSLocalizedString(@"task status doing", nil);
        taskStatusLabel.textColor = [UIColor greenColor];
    } else if (task.status.intValue == BTT_TASK_DONE) {
        taskStatusLabel.text = NSLocalizedString(@"task status done", nil);
        taskStatusLabel.textColor = [UIColor grayColor];
    }

    totalDaysStringLabel.frame = CGRectMake(90, 2, 80, 26);
    totalDaysStringLabel.textAlignment = NSTextAlignmentRight;
    totalDaysStringLabel.font = [UIFont systemFontOfSize:12];
    totalDaysStringLabel.text = NSLocalizedString(@"total days", nil);

    totalDaysLabel.frame = CGRectMake(172, 2, 24, 26);
    totalDaysLabel.textAlignment = NSTextAlignmentLeft;
    totalDaysLabel.font = [UIFont systemFontOfSize:12];
    totalDaysLabel.textColor = [UIColor redColor];
    totalDaysLabel.text = task.totalDays.stringValue;

    currentDaysStringLabel.frame = CGRectMake(200, 2, 80, 26);
    currentDaysStringLabel.textAlignment = NSTextAlignmentRight;
    currentDaysStringLabel.font = [UIFont systemFontOfSize:12];
    currentDaysStringLabel.text = NSLocalizedString(@"current days", nil);

    currentDaysLabel.frame = CGRectMake(282, 2, 24, 26);
    currentDaysLabel.textAlignment = NSTextAlignmentLeft;
    currentDaysLabel.font = [UIFont systemFontOfSize:12];
    currentDaysLabel.textColor = [UIColor redColor];
    currentDaysLabel.text = [NSString stringWithFormat:@"%d", currentDays];

    checkedDaysStringLabel.frame = CGRectMake(90, 30, 80, 26);
    checkedDaysStringLabel.textAlignment = NSTextAlignmentRight;
    checkedDaysStringLabel.font = [UIFont systemFontOfSize:12];
    checkedDaysStringLabel.text = NSLocalizedString(@"checked days", nil);

    checkedDaysLabel.frame = CGRectMake(172, 30, 24, 26);
    checkedDaysLabel.textAlignment = NSTextAlignmentLeft;
    checkedDaysLabel.font = [UIFont systemFontOfSize:12];
    checkedDaysLabel.textColor = [UIColor greenColor];
    checkedDaysLabel.text = task.checkedDays.stringValue;

    uncheckedDaysStringLabel.frame = CGRectMake(200, 30, 80, 26);
    uncheckedDaysStringLabel.textAlignment = NSTextAlignmentRight;
    uncheckedDaysStringLabel.font = [UIFont systemFontOfSize:12];
    uncheckedDaysStringLabel.text = NSLocalizedString(@"unchecked days", nil);

    uncheckedDaysLabel.frame = CGRectMake(282, 30, 24, 26);
    uncheckedDaysLabel.textAlignment = NSTextAlignmentLeft;
    uncheckedDaysLabel.font = [UIFont systemFontOfSize:12];
    uncheckedDaysLabel.textColor = [UIColor redColor];
    NSInteger uncheckedDays = currentDays - task.checkedDays.intValue;
    uncheckedDaysLabel.text = [NSString stringWithFormat:@"%d", uncheckedDays];
}

- (void)setTask:(BTTTask *)taskParam currentDays:(NSInteger)currentDaysParam {
    task = taskParam;
    currentDays = currentDaysParam;

    [self layoutContentView];
}

@end