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
#import "BTTWeekView.h"
#import "BTTConfig.h"

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
@property (strong, nonatomic) UILabel *currentCheckinLabel;
@property (strong, nonatomic) UILabel *previousCheckinLabel;
@property (strong, nonatomic) UILabel *nextCheckinLabel;
@property (strong, nonatomic) UIButton *currentCheckinButton;
@property (strong, nonatomic) NSArray *viewArray;
@property (strong, nonatomic) BTTHorizontalSlideView *slideView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) BTTWeekView *weekView;
@property (strong, nonatomic) UIView *middleMainView;

@property (strong, nonatomic) BTTTask *task;
@property (strong, nonatomic) BTTTaskDao *taskDao;
@property (strong, nonatomic) BTTTaskItem *taskItem;
@property (strong, nonatomic) BTTTaskItem *previousTaskItem;
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
@synthesize currentCheckinLabel;
@synthesize previousCheckinLabel;
@synthesize nextCheckinLabel;
@synthesize viewArray;
@synthesize slideView;
@synthesize task;
@synthesize taskDao;
@synthesize taskItem;
@synthesize taskItemDao;
@synthesize previousTaskItem;
@synthesize titleLabel;
@synthesize weekView;
@synthesize middleMainView;

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

        NSInteger yesterdayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1 - 1;
        previousTaskItem = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:yesterdayCurrentDays]];
    }
}

- (void)setValue {
    titleLabel.text = task.title;

    NSDate *now = [NSDate new];
    currentDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:now];

    NSTimeInterval yesterdayInterval = PER_DAY_INTERVAL * -1;
    NSDate *yesterday = [now initWithTimeIntervalSinceNow:yesterdayInterval];
    previousDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:yesterday];

    NSTimeInterval tomorrowInterval = PER_DAY_INTERVAL * 1;
    NSDate *tomorrow = [now initWithTimeIntervalSinceNow:tomorrowInterval];
    nextDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:tomorrow];

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
    currentCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays];
    previousCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays - 1];
    nextCountLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + 1];

    if (todayCurrentDays == 1) {
        [slideView bindLeftSwipeRecognizer:current];
    } else if (todayCurrentDays == 1 + 1) {
        [slideView bindLeftSwipeRecognizer:previous];
    }
    if (todayCurrentDays == BTT_INSIST_DAYS_COUNT) {
        [slideView bindRightSwipeRecognizer:current];
    } else if (todayCurrentDays == BTT_INSIST_DAYS_COUNT - 1) {
        [slideView bindRightSwipeRecognizer:next];
    }

    if (taskItem && taskItem.checked) {
        currentCheckinButton.hidden = YES;
        currentCheckinLabel.hidden = NO;
        currentCheckinLabel.text = NSLocalizedString(@"checked", nil);
    } else {
        currentCheckinButton.hidden = NO;
        currentCheckinLabel.hidden = YES;
        currentCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
    }

    if (previousTaskItem && previousTaskItem.checked) {
        previousCheckinLabel.text = NSLocalizedString(@"checked", nil);
    } else {
        previousCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
    }

    nextCheckinLabel.text = NSLocalizedString(@"not start", nil);

    viewArray = [[NSArray alloc] initWithObjects:previous, current, next, nil];

    NSArray *weekTaskItemArray = [self loadWeekViewData:now todayCurrentDays:todayCurrentDays];
    [weekView setWeekTaskItemArray:weekTaskItemArray];
}

- (void)drawView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
//    topView.backgroundColor = [UIColor redColor];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 280, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];

    weekView = [[BTTWeekView alloc] initWithFrame:CGRectMake(0, 30, topView.bounds.size.width, topView.bounds.size.height - 30)];

    [topView addSubview:titleLabel];
    [topView addSubview:weekView];

    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];

    UIView *middleBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, middleView.bounds.size.height - 60, SCREEN_WIDTH, 60)];

    UIButton *middleBottomTodayButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 6, 24, 24)];
    [middleBottomTodayButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [middleBottomTodayButton addTarget:self action:@selector(backToday) forControlEvents:UIControlEventTouchDown];
    [middleBottomView addSubview:middleBottomTodayButton];

    UIButton *middleBottomSettingsButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 6, 24, 24)];
    [middleBottomSettingsButton setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [middleBottomSettingsButton addTarget:self action:@selector(gotoSetup) forControlEvents:UIControlEventTouchDown];
    [middleBottomView addSubview:middleBottomSettingsButton];

    middleMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, middleView.bounds.size.height - 60)];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    lineView.backgroundColor = [UIColor grayColor];


    UILabel *currentDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    currentDateStringLabel.textAlignment = NSTextAlignmentRight;
    currentDateStringLabel.text = NSLocalizedString(@"date", nil);

    currentDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    currentDateLabel.textColor = [UIColor redColor];
    currentDateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *currentCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    currentCountStringLabel.textAlignment = NSTextAlignmentRight;
    currentCountStringLabel.text = NSLocalizedString(@"days", nil);

    currentCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    currentCountLabel.textColor = [UIColor redColor];
    currentCountLabel.textAlignment = NSTextAlignmentLeft;

    currentCheckinButton = [[UIButton alloc] initWithFrame:CGRectMake(100, middleMainView.bounds.size.height - 40, 100, 30)];
    [currentCheckinButton setTitle:NSLocalizedString(@"checkin", nil) forState:UIControlStateNormal];
    currentCheckinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    currentCheckinButton.backgroundColor = [UIColor redColor];
    [currentCheckinButton addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchDown];

    currentCheckinLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, middleMainView.bounds.size.height - 40, 100, 30)];
    currentCheckinLabel.textAlignment = NSTextAlignmentCenter;
    currentCheckinLabel.font = [UIFont boldSystemFontOfSize:14];

    current = [[UIView alloc] initWithFrame:middleMainView.bounds];
    current.backgroundColor = [UIColor whiteColor];
    current.tag = 0;
    [current addSubview:currentDateLabel];
    [current addSubview:currentCountLabel];
    [current addSubview:currentDateStringLabel];
    [current addSubview:currentCountStringLabel];
    [current addSubview:currentCheckinButton];
    [current addSubview:currentCheckinLabel];

    UILabel *previousDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    previousDateStringLabel.textAlignment = NSTextAlignmentRight;
    previousDateStringLabel.text = NSLocalizedString(@"date", nil);

    previousDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    previousDateLabel.textColor = [UIColor redColor];
    previousDateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *previousCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    previousCountStringLabel.textAlignment = NSTextAlignmentRight;
    previousCountStringLabel.text = NSLocalizedString(@"days", nil);

    previousCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    previousCountLabel.textColor = [UIColor redColor];
    previousCountLabel.textAlignment = NSTextAlignmentLeft;

//    previousCheckinButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 100, 30)];
//    [previousCheckinButton setTitle:@"checkin" forState:UIControlStateNormal];
//    previousCheckinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    previousCheckinButton.backgroundColor = [UIColor redColor];

    previousCheckinLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, middleMainView.bounds.size.height - 40, 100, 30)];
    previousCheckinLabel.textAlignment = NSTextAlignmentCenter;
    previousCheckinLabel.font = [UIFont boldSystemFontOfSize:14];

    previous = [[UIView alloc] initWithFrame:middleMainView.bounds];
    previous.backgroundColor = [UIColor whiteColor];
    previous.tag = -1;
    [previous addSubview:previousDateLabel];
    [previous addSubview:previousCountLabel];
    [previous addSubview:previousDateStringLabel];
    [previous addSubview:previousCountStringLabel];
//    [previous addSubview:previousCheckinButton];
    [previous addSubview:previousCheckinLabel];

    UILabel *nextDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    nextDateStringLabel.textAlignment = NSTextAlignmentRight;
    nextDateStringLabel.text = NSLocalizedString(@"date", nil);

    nextDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    nextDateLabel.textColor = [UIColor redColor];
    nextDateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *nextCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    nextCountStringLabel.textAlignment = NSTextAlignmentRight;
    nextCountStringLabel.text = NSLocalizedString(@"days", nil);

    nextCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    nextCountLabel.textColor = [UIColor redColor];
    nextCountLabel.textAlignment = NSTextAlignmentLeft;

//    nextCheckinButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 140, 100, 30)];
//    [nextCheckinButton setTitle:@"checkin" forState:UIControlStateNormal];
//    nextCheckinButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    nextCheckinButton.backgroundColor = [UIColor redColor];

    nextCheckinLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, middleMainView.bounds.size.height - 40, 100, 30)];
    nextCheckinLabel.textAlignment = NSTextAlignmentCenter;
    nextCheckinLabel.font = [UIFont boldSystemFontOfSize:14];

    next = [[UIView alloc] initWithFrame:middleMainView.bounds];
    next.backgroundColor = [UIColor whiteColor];
    next.tag = 1;
    [next addSubview:nextDateLabel];
    [next addSubview:nextCountLabel];
    [next addSubview:nextDateStringLabel];
    [next addSubview:nextCountStringLabel];
//    [next addSubview:nextCheckinButton];
    [next addSubview:nextCheckinLabel];

    slideView = [[BTTHorizontalSlideView alloc] initWithView:current previous:previous next:next frame:middleMainView.bounds];
    slideView.delegate = self;

    [middleMainView addSubview:slideView];
    [middleMainView addSubview:lineView];

    [middleView addSubview:middleMainView];
    [middleView addSubview:middleBottomView];

    [self.view addSubview:topView];
    [self.view addSubview:middleView];

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
        if (weekView) {
            [weekView removeFromSuperview];
        }
        [self drawView];
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
    currentCheckinLabel.hidden = NO;
    currentCheckinLabel.text = NSLocalizedString(@"checked", nil);

    NSArray *weekTaskItemArray = [self loadWeekViewData:now todayCurrentDays:todayCurrentDays];
    [weekView setWeekTaskItemArray:weekTaskItemArray];
}

- (void)backToday {
    if (weekView) {
        [weekView removeFromSuperview];
    }
    [self drawView];

    [self setValue];
}

- (void)gotoSetup {
    BTTSetupController *setupController = [[BTTSetupController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setupController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - BTTHorizontalSlideViewDelegate method
- (void)setupViewData:(NSInteger)selectedIndex countIndex:(NSInteger)countIndex {
    NSDate *now = [NSDate new];
    NSTimeInterval currentInterval = PER_DAY_INTERVAL * countIndex;
    NSTimeInterval previousInterval = PER_DAY_INTERVAL * (countIndex - 1);
    NSTimeInterval nextInterval = PER_DAY_INTERVAL * (countIndex + 1);
    NSDate *currentDate = [now initWithTimeIntervalSinceNow:currentInterval];
    NSDate *previousDate = [now initWithTimeIntervalSinceNow:previousInterval];
    NSDate *nextDate = [now initWithTimeIntervalSinceNow:nextInterval];

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
//    NSLog(@"countIndex : %d", countIndex);
//    NSLog(@"todayCurrentDays : %d", todayCurrentDays);

    NSArray *weekTaskItemArray = [self loadWeekViewData:currentDate todayCurrentDays:todayCurrentDays];
    [weekView setWeekTaskItemArray:weekTaskItemArray];

    if (selectedIndex > 0) {
        NSMutableArray *viewArrayTmp = [NSMutableArray array];
        [viewArrayTmp addObject:[viewArray objectAtIndex:1]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:2]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:0]];
        viewArray = viewArrayTmp;
//        NSLog(@"%@", [BTTDateUtil convertDateToDateStringByDefaultPattern:currentDate]);

        NSInteger currentDays = todayCurrentDays + countIndex + 1;
        BTTTaskItem *item = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:currentDays]];

        UIView *v = viewArray.lastObject;
        if (v.tag > 0) {
            nextDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            nextCountLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                nextCheckinLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:currentDate]) {
                    nextCheckinLabel.text = NSLocalizedString(@"not start", nil);
                } else {
                    nextCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                }
            }
        } else if (v.tag < 0) {
            previousDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            previousCountLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                previousCheckinLabel.text = NSLocalizedString(@"checked", nil);;
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:now]) {
                    previousCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    previousCheckinLabel.text = NSLocalizedString(@"not start", nil);
                }
            }
        } else {
            currentDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            currentCountLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                currentCheckinButton.hidden = YES;
                currentCheckinLabel.hidden = NO;
                currentCheckinLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == -1) {
                    currentCheckinButton.hidden = NO;
                    currentCheckinLabel.hidden = YES;
                    currentCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    if ([[currentDate laterDate:now] isEqualToDate:now]) {
                        currentCheckinButton.hidden = YES;
                        currentCheckinLabel.hidden = NO;
                        currentCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                    } else {
                        currentCheckinButton.hidden = YES;
                        currentCheckinLabel.hidden = NO;
                        currentCheckinLabel.text = NSLocalizedString(@"not start", nil);
                    }
                }
            }
        }

        BOOL isEnd = currentDays == BTT_INSIST_DAYS_COUNT ? YES : NO;
        [slideView switchView:v isEnd:isEnd];
    } else if (selectedIndex < 0) {
        NSMutableArray *viewArrayTmp = [NSMutableArray array];
        [viewArrayTmp addObject:[viewArray objectAtIndex:2]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:0]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:1]];
        viewArray = viewArrayTmp;

        NSInteger currentDays = todayCurrentDays + countIndex - 1;
        BTTTaskItem *item = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:currentDays]];

        UIView *v = [viewArray objectAtIndex:0];
        if (v.tag > 0) {
            nextDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            nextCountLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                nextCheckinLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:now]) {
                    nextCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    nextCheckinLabel.text = NSLocalizedString(@"not start", nil);
                }
            }
        } else if (v.tag < 0) {
            previousDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            previousCountLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                previousCheckinLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:now]) {
                    previousCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    previousCheckinLabel.text = NSLocalizedString(@"not start", nil);
                }
            }
        } else {
            currentDateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            currentCountLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                currentCheckinButton.hidden = YES;
                currentCheckinLabel.hidden = NO;
                currentCheckinLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 1) {
                    currentCheckinButton.hidden = NO;
                    currentCheckinLabel.hidden = YES;
                    currentCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    if ([[currentDate laterDate:now] isEqualToDate:now]) {
                        currentCheckinButton.hidden = YES;
                        currentCheckinLabel.hidden = NO;
                        currentCheckinLabel.text = NSLocalizedString(@"unchecked", nil);
                    } else {
                        currentCheckinButton.hidden = YES;
                        currentCheckinLabel.hidden = NO;
                        currentCheckinLabel.text = NSLocalizedString(@"not start", nil);
                    }
                }
            }
        }

        BOOL isEnd = currentDays == 1 ? YES : NO;
        [slideView switchView:v isEnd:isEnd];
    }

}

- (NSArray *)loadWeekViewData:(NSDate *)currentDate todayCurrentDays:(NSInteger)todayCurrentDays {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:currentDate];
    int weekday = [comps weekday];
//    NSLog(@"currentDate day : %d", weekday);
//    NSLog(@"currentDate : %@", [BTTDateUtil convertDateToDateStringByDefaultPattern:currentDate]);
    NSDate *firstWeekDate = [currentDate dateByAddingTimeInterval:(-1 * weekday + 1) * PER_DAY_INTERVAL];
//    NSLog(@"first currentDate : %@", [BTTDateUtil convertDateToDateStringByDefaultPattern:firstWeekDate]);
//    NSLog(@"last currentDate : %@", [BTTDateUtil convertDateToDateStringByDefaultPattern:[currentDate initWithTimeIntervalSinceNow:24 * 60 * 60 * (7 - weekday)]]);
//    NSLog(@"first currentDate days : %d", [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:firstWeekDate] + 1);
    NSMutableArray *_weekTaskItemArray = [[NSMutableArray alloc] init];
    for (int i =0; i < WEEK_DAYS_COUNT; i ++) {
        NSDate *weekDate = [firstWeekDate dateByAddingTimeInterval:i * PER_DAY_INTERVAL];
//        NSLog(@"weekdate : %@", [BTTDateUtil convertDateToDateStringByDefaultPattern:weekDate]);
        NSUInteger weekDateCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:weekDate] + 1;
//        NSLog(@"weekDateCurrentDays : %d", weekDateCurrentDays);

        BTTTaskItem *_taskItem = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:weekDateCurrentDays]];
        if (!_taskItem) {
            _taskItem = [[BTTTaskItem alloc] init];
            _taskItem.checked = [NSNumber numberWithInteger:0];
        }

        if (weekDateCurrentDays <= 0 || weekDateCurrentDays > BTT_INSIST_DAYS_COUNT) {
            _taskItem.in100days = NO;
        } else {
            _taskItem.in100days = YES;
        }

        if (todayCurrentDays < weekDateCurrentDays) {
            _taskItem.afterToday = YES;
        } else {
            _taskItem.afterToday = NO;
        }

        if (i + 1 == weekday) {
            _taskItem.currentDate = YES;
        } else {
            _taskItem.currentDate = NO;
        }

        [_weekTaskItemArray addObject:_taskItem];
    }
    return _weekTaskItemArray;
}

@end