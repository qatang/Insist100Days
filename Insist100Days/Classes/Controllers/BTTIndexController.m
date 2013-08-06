//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTIndexController.h"
#import "BTTHorizontalSlideView.h"
#import "BTTDateUtil.h"
#import "BTTSetupController.h"
#import "BTTTaskDao.h"
#import "BTTTaskItem.h"
#import "BTTTaskItemDao.h"
#import "BTTEnums.h"

@interface BTTIndexController()

@property (strong, nonatomic) UIView *current;
@property (strong, nonatomic) UIView *previous;
@property (strong, nonatomic) UIView *next;
@property (strong, nonatomic) UILabel *currentDateLabel;
@property (strong, nonatomic) UILabel *previousDateLabel;
@property (strong, nonatomic) UILabel *nextDateLabel;
@property (strong, nonatomic) UILabel *currentCountLabel;
@property (strong, nonatomic) UILabel *previousCountLabel;
@property (strong, nonatomic) UILabel *nextCountLabel;
@property (strong, nonatomic) UIButton *currentCheckinButton;
@property (strong, nonatomic) UIButton *previousCheckinButton;
@property (strong, nonatomic) UIButton *nextCheckinButton;
@property (strong, nonatomic) NSArray *viewArray;
@property (strong, nonatomic) BTTHorizontalSlideView *slideView;

@property (strong, nonatomic) BTTTask *task;
@property (strong, nonatomic) BTTTaskDao *taskDao;
@property (strong, nonatomic) BTTTaskItem *taskItem;
@property (strong, nonatomic) BTTTaskItemDao *taskItemDao;

@end

@implementation BTTIndexController

@synthesize current;
@synthesize previous;
@synthesize next;
@synthesize currentDateLabel;
@synthesize previousDateLabel;
@synthesize nextDateLabel;
@synthesize currentCountLabel;
@synthesize previousCountLabel;
@synthesize nextCountLabel;
@synthesize currentCheckinButton;
@synthesize previousCheckinButton;
@synthesize nextCheckinButton;
@synthesize viewArray;
@synthesize slideView;
@synthesize task;
@synthesize taskDao;
@synthesize taskItem;
@synthesize taskItemDao;

- (void)loadData {
    if (!taskDao) {
        taskDao = [[BTTTaskDao alloc] init];
    }
    task = [taskDao getCurrent];

    if (task) {
        if (!taskItemDao) {
            taskItemDao = [[BTTTaskItemDao alloc] init];
        }
        NSDate *now = [NSDate new];
        NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
        taskItem = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:todayCurrentDays]];
    }
}

- (void)setValue {
    NSDate *now = [NSDate new];
    currentDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:now];

    NSTimeInterval yesterdayInterval = 24 * 60 * 60 * -1;
    NSDate *yesterday = [now initWithTimeIntervalSinceNow:yesterdayInterval];
    previousDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:yesterday];

    NSTimeInterval tomorrowInterval = 24 * 60 * 60 * 1;
    NSDate *tomorrow = [now initWithTimeIntervalSinceNow:tomorrowInterval];
    nextDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:tomorrow];

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
    currentCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays];
    previousCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays - 1];
    nextCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + 1];

    if (taskItem) {
        currentCheckinButton.hidden = YES;
    } else {
        currentCheckinButton.hidden = NO;
    }
}

- (void)drawView {
    UIView *topView = [self.view.subviews objectAtIndex:0];
    topView.backgroundColor = [UIColor redColor];

    UIView *middleView = [self.view.subviews objectAtIndex:1];
    UIView *middleMainView = [middleView.subviews objectAtIndex:0];

    UIView *middleBottomView = [middleView.subviews objectAtIndex:1];
    UIButton *middleBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 13, 24, 24)];
    [middleBottomButton setBackgroundImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    [middleBottomButton addTarget:self action:@selector(gotoSetup) forControlEvents:UIControlEventTouchDown];
    [middleBottomView addSubview:middleBottomButton];

    UILabel *currentDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    currentDateStringLabel.textAlignment = NSTextAlignmentRight;
    currentDateStringLabel.text = @"今天是：";

    currentDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    currentDateLabel.textColor = [UIColor redColor];
    currentDateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *currentCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    currentCountStringLabel.textAlignment = NSTextAlignmentRight;
    currentCountStringLabel.text = @"天数：";

    currentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    currentCountLabel.textColor = [UIColor redColor];
    currentCountLabel.textAlignment = NSTextAlignmentLeft;

    currentCheckinButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 100, 30)];
    [currentCheckinButton setTitle:@"checkin" forState:UIControlStateNormal];
    currentCheckinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    currentCheckinButton.backgroundColor = [UIColor redColor];
    [currentCheckinButton addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchDown];

    current = [[UIView alloc] initWithFrame:middleMainView.bounds];
    current.backgroundColor = [UIColor whiteColor];
    current.tag = 0;
    [current addSubview:currentDateLabel];
    [current addSubview:currentCountLabel];
    [current addSubview:currentDateStringLabel];
    [current addSubview:currentCountStringLabel];
    [current addSubview:currentCheckinButton];

    UILabel *previousDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    previousDateStringLabel.textAlignment = NSTextAlignmentRight;
    previousDateStringLabel.text = @"今天是：";

    previousDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    previousDateLabel.textColor = [UIColor redColor];
    previousDateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *previousCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    previousCountStringLabel.textAlignment = NSTextAlignmentRight;
    previousCountStringLabel.text = @"天数：";

    previousCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    previousCountLabel.textColor = [UIColor redColor];
    previousCountLabel.textAlignment = NSTextAlignmentLeft;

//    previousCheckinButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 100, 30)];
//    [previousCheckinButton setTitle:@"checkin" forState:UIControlStateNormal];
//    previousCheckinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    previousCheckinButton.backgroundColor = [UIColor redColor];

    previous = [[UIView alloc] initWithFrame:middleMainView.bounds];
    previous.backgroundColor = [UIColor whiteColor];
    previous.tag = -1;
    [previous addSubview:previousDateLabel];
    [previous addSubview:previousCountLabel];
    [previous addSubview:previousDateStringLabel];
    [previous addSubview:previousCountStringLabel];
//    [previous addSubview:previousCheckinButton];

    UILabel *nextDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    nextDateStringLabel.textAlignment = NSTextAlignmentRight;
    nextDateStringLabel.text = @"今天是：";

    nextDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    nextDateLabel.textColor = [UIColor redColor];
    nextDateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *nextCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    nextCountStringLabel.textAlignment = NSTextAlignmentRight;
    nextCountStringLabel.text = @"天数：";

    nextCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    nextCountLabel.textColor = [UIColor redColor];
    nextCountLabel.textAlignment = NSTextAlignmentLeft;

//    nextCheckinButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 100, 30)];
//    [nextCheckinButton setTitle:@"checkin" forState:UIControlStateNormal];
//    nextCheckinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    nextCheckinButton.backgroundColor = [UIColor redColor];

    next = [[UIView alloc] initWithFrame:middleMainView.bounds];
    next.backgroundColor = [UIColor whiteColor];
    next.tag = 1;
    [next addSubview:nextDateLabel];
    [next addSubview:nextCountLabel];
    [next addSubview:nextDateStringLabel];
    [next addSubview:nextCountStringLabel];
//    [next addSubview:nextCheckinButton];

    viewArray = [[NSArray alloc] initWithObjects:previous, current, next, nil];

    slideView = [[BTTHorizontalSlideView alloc] initWithView:current previous:previous next:next frame:middleMainView.bounds];
    slideView.delegate = self;

    [middleMainView addSubview:slideView];
}

- (void)viewDidLoad {
    [self loadData];
    [self drawView];
    [self setValue];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!taskDao) {
        taskDao = [[BTTTaskDao alloc] init];
    }
    BTTTask *currentTask = [taskDao getCurrent];
    if (task.taskId != currentTask.taskId) {
        [self loadData];
        [self setValue];
    }
}

- (void)checkin {
    BTTTaskItem *item = [[BTTTaskItem alloc] init];
    item.taskId = task.taskId;
    item.checked = [NSNumber numberWithInteger:BTT_YES];
    NSDate *now = [NSDate new];
    item.createdTime = now;
    item.updatedTime = now;

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
    item.currentDays = [NSNumber numberWithInteger:todayCurrentDays];
    [taskItemDao save:item];

    currentCheckinButton.hidden = YES;
}

- (void)gotoSetup {
    BTTSetupController *setupController = [[BTTSetupController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setupController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - BTTHorizontalSlideViewDelegate method
- (void)setupViewData:(NSInteger)selectedIndex countIndex:(NSInteger)countIndex {
    NSDate *now = [NSDate new];
    NSTimeInterval currentInterval = 24 * 60 * 60 * countIndex;
    NSTimeInterval previousInterval = 24 * 60 * 60 * (countIndex - 1);
    NSTimeInterval nextInterval = 24 * 60 * 60 * (countIndex + 1);
    NSDate *currentDate = [now initWithTimeIntervalSinceNow:currentInterval];
    NSDate *previousDate = [now initWithTimeIntervalSinceNow:previousInterval];
    NSDate *nextDate = [now initWithTimeIntervalSinceNow:nextInterval];

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
//    NSLog(@"countIndex : %d", countIndex);
//    NSLog(@"todayCurrentDays : %d", todayCurrentDays);
    if (selectedIndex > 0) {
        NSMutableArray *viewArrayTmp = [NSMutableArray array];
        [viewArrayTmp addObject:[viewArray objectAtIndex:1]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:2]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:0]];
        viewArray = viewArrayTmp;
        NSLog(@"%@", [BTTDateUtil convertDateToDateStringByDefaultPattern:currentDate]);
        UIView *v = viewArray.lastObject;
        if (v.tag > 0) {
            nextDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            nextCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + countIndex + 1];
        } else if (v.tag < 0) {
            previousDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            previousCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + countIndex + 1];
        } else {
            currentDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            currentCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + countIndex + 1];
        }


        [slideView switchView:v];
    } else if (selectedIndex < 0) {
        NSMutableArray *viewArrayTmp = [NSMutableArray array];
        [viewArrayTmp addObject:[viewArray objectAtIndex:2]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:0]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:1]];
        viewArray = viewArrayTmp;

        UIView *v = [viewArray objectAtIndex:0];
        if (v.tag > 0) {
            nextDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            nextCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + countIndex - 1];
        } else if (v.tag < 0) {
            previousDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            previousCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + countIndex - 1];
        } else {
            currentDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            currentCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + countIndex - 1];
        }


        [slideView switchView:v];
    }

}

@end