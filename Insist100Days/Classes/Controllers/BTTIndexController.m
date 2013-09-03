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
#import "BTTHorizontalSlideInsideView.h"
#import "BTTFirstBloodViewController.h"

@interface BTTIndexController()

@property (strong, nonatomic) BTTHorizontalSlideInsideView *current;
@property (strong, nonatomic) BTTHorizontalSlideInsideView *previous;
@property (strong, nonatomic) BTTHorizontalSlideInsideView *next;
//@property (strong, nonatomic) UILabel *currentDateLabel;
//@property (strong, nonatomic) UILabel *previousDateLabel;
//@property (strong, nonatomic) UILabel *nextDateLabel;
//@property (strong, nonatomic) UILabel *currentCountLabel;
//@property (strong, nonatomic) UILabel *previousCountLabel;
//@property (strong, nonatomic) UILabel *nextCountLabel;
//@property (strong, nonatomic) UILabel *currentCheckinLabel;
//@property (strong, nonatomic) UILabel *previousCheckinLabel;
//@property (strong, nonatomic) UILabel *nextCheckinLabel;
//@property (strong, nonatomic) UIButton *currentCheckinButton;
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
//@synthesize currentDateLabel;
//@synthesize previousDateLabel;
//@synthesize nextDateLabel;
//@synthesize currentCountLabel;
//@synthesize previousCountLabel;
//@synthesize nextCountLabel;
//@synthesize currentCheckinButton;
//@synthesize currentCheckinLabel;
//@synthesize previousCheckinLabel;
//@synthesize nextCheckinLabel;
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

- (void)loadData:(NSDate *)theDate {
    if (!taskDao) {
        taskDao = [[BTTTaskDao alloc] init];
    }
    task = [taskDao getCurrent];

    if (task) {
        if (!taskItemDao) {
            taskItemDao = [[BTTTaskItemDao alloc] init];
        }
        NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:theDate] + 1;
        taskItem = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:todayCurrentDays]];

        NSInteger yesterdayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:theDate] + 1 - 1;
        previousTaskItem = [taskItemDao get:task.taskId currentDays:[NSNumber numberWithInteger:yesterdayCurrentDays]];
    }
}

- (void)setValue:(NSDate *)theDate {
    titleLabel.text = task.title;

    current = [[BTTHorizontalSlideInsideView alloc] initWithFrame:middleMainView.bounds];
    current.delegate = self;
    current.tag = 0;

    previous = [[BTTHorizontalSlideInsideView alloc] initWithFrame:middleMainView.bounds];
    previous.tag = -1;

    next = [[BTTHorizontalSlideInsideView alloc] initWithFrame:middleMainView.bounds];
    next.tag = 1;

    slideView = [[BTTHorizontalSlideView alloc] initWithView:current previous:previous next:next frame:middleMainView.bounds];
    slideView.delegate = self;

    [middleMainView addSubview:slideView];

    current.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:theDate];

    NSTimeInterval yesterdayInterval = PER_DAY_INTERVAL * -1;
    NSDate *yesterday = [theDate initWithTimeIntervalSinceNow:yesterdayInterval];
    previous.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:yesterday];

    NSTimeInterval tomorrowInterval = PER_DAY_INTERVAL * 1;
    NSDate *tomorrow = [theDate initWithTimeIntervalSinceNow:tomorrowInterval];
    next.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:tomorrow];

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:theDate] + 1;
    current.countLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays];
    previous.countLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays - 1];
    next.countLabel.text = [NSString stringWithFormat:@"%d", todayCurrentDays + 1];

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
        current.checkInButton.hidden = YES;
        current.checkInLabel.hidden = NO;
        current.checkInLabel.text = NSLocalizedString(@"checked", nil);
    } else {
        current.checkInButton.hidden = NO;
        current.checkInLabel.hidden = YES;
        current.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
    }

    if (previousTaskItem && previousTaskItem.checked) {
        previous.checkInButton.hidden = YES;
        previous.checkInLabel.hidden = NO;
        previous.checkInLabel.text = NSLocalizedString(@"checked", nil);
    } else {
        previous.checkInButton.hidden = YES;
        previous.checkInLabel.hidden = NO;
        previous.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
    }

    next.checkInButton.hidden = YES;
    next.checkInLabel.hidden = NO;
    next.checkInLabel.text = NSLocalizedString(@"not start", nil);

    viewArray = [[NSArray alloc] initWithObjects:previous, current, next, nil];

    NSArray *weekTaskItemArray = [self loadWeekViewData:theDate todayCurrentDays:todayCurrentDays];
    [weekView setWeekTaskItemArray:weekTaskItemArray];
}

- (void)drawView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 4, 280, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:14];

    weekView = [[BTTWeekView alloc] initWithFrame:CGRectMake(0, 30, topView.bounds.size.width, topView.bounds.size.height - 30)];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.bounds.size.height - 2, SCREEN_WIDTH, 2)];
    lineView.backgroundColor = [UIColor grayColor];

    [topView addSubview:titleLabel];
    [topView addSubview:weekView];
    [topView addSubview:lineView];

    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, SCREEN_HEIGHT - 84)];

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

    [middleView addSubview:middleMainView];
    [middleView addSubview:middleBottomView];

    [self.view addSubview:topView];
    [self.view addSubview:middleView];

}

- (void)viewDidLoad {
    NSDate *now = [NSDate date];

    [self loadData:now];
    [self drawView];
    [self setValue:now];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!taskDao) {
        taskDao = [[BTTTaskDao alloc] init];
    }
    BTTTask *currentTask = [taskDao getCurrent];
    if (task.taskId != currentTask.taskId) {
        NSDate *now = [NSDate date];
        [self loadData:now];
        [self setValue:now];
    }
}

- (void)backToday {
    NSDate *now = [NSDate date];
    [self loadData:now];
    [self setValue:now];
}

- (void)gotoSetup {
    BTTSetupController *setupController = [[BTTSetupController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setupController];

    [self presentViewController:navigationController animated:YES completion:nil];
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

#pragma mark - BTTHorizontalSlideViewDelegate method
- (void)setupViewData:(NSInteger)selectedIndex countIndex:(NSInteger)countIndex {
    NSDate *now = [NSDate date];
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
            next.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            next.countLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                next.checkInButton.hidden = YES;
                next.checkInLabel.hidden = NO;
                next.checkInLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:currentDate]) {
                    next.checkInButton.hidden = YES;
                    next.checkInLabel.hidden = NO;
                    next.checkInLabel.text = NSLocalizedString(@"not start", nil);
                } else {
                    next.checkInButton.hidden = YES;
                    next.checkInLabel.hidden = NO;
                    next.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                }
            }
        } else if (v.tag < 0) {
            previous.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            previous.countLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                previous.checkInButton.hidden = YES;
                previous.checkInLabel.hidden = NO;
                previous.checkInLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:now]) {
                    previous.checkInButton.hidden = YES;
                    previous.checkInLabel.hidden = NO;
                    previous.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    previous.checkInButton.hidden = YES;
                    previous.checkInLabel.hidden = NO;
                    previous.checkInLabel.text = NSLocalizedString(@"not start", nil);
                }
            }
        } else {
            current.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
            current.countLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                current.checkInButton.hidden = YES;
                current.checkInLabel.hidden = NO;
                current.checkInLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == -1) {
                    current.checkInButton.hidden = NO;
                    current.checkInLabel.hidden = YES;
                    current.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    if ([[currentDate laterDate:now] isEqualToDate:now]) {
                        current.checkInButton.hidden = YES;
                        current.checkInLabel.hidden = NO;
                        current.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                    } else {
                        current.checkInButton.hidden = YES;
                        current.checkInLabel.hidden = NO;
                        current.checkInLabel.text = NSLocalizedString(@"not start", nil);
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
            next.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            next.countLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                next.checkInButton.hidden = YES;
                next.checkInLabel.hidden = NO;
                next.checkInLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:now]) {
                    next.checkInButton.hidden = YES;
                    next.checkInLabel.hidden = NO;
                    next.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    next.checkInButton.hidden = YES;
                    next.checkInLabel.hidden = NO;
                    next.checkInLabel.text = NSLocalizedString(@"not start", nil);
                }
            }
        } else if (v.tag < 0) {
            previous.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            previous.countLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                previous.checkInButton.hidden = YES;
                previous.checkInLabel.hidden = NO;
                previous.checkInLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 0 || [[currentDate laterDate:now] isEqualToDate:now]) {
                    previous.checkInButton.hidden = YES;
                    previous.checkInLabel.hidden = NO;
                    previous.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    previous.checkInButton.hidden = YES;
                    previous.checkInLabel.hidden = NO;
                    previous.checkInLabel.text = NSLocalizedString(@"not start", nil);
                }
            }
        } else {
            current.dateLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
            current.countLabel.text = [NSString stringWithFormat:@"%d", currentDays];
            if (item && item.checked) {
                current.checkInButton.hidden = YES;
                current.checkInLabel.hidden = NO;
                current.checkInLabel.text = NSLocalizedString(@"checked", nil);
            } else {
                if (countIndex == 1) {
                    current.checkInButton.hidden = NO;
                    current.checkInLabel.hidden = YES;
                    current.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                } else {
                    if ([[currentDate laterDate:now] isEqualToDate:now]) {
                        current.checkInButton.hidden = YES;
                        current.checkInLabel.hidden = NO;
                        current.checkInLabel.text = NSLocalizedString(@"unchecked", nil);
                    } else {
                        current.checkInButton.hidden = YES;
                        current.checkInLabel.hidden = NO;
                        current.checkInLabel.text = NSLocalizedString(@"not start", nil);
                    }
                }
            }
        }

        BOOL isEnd = currentDays == 1 ? YES : NO;
        [slideView switchView:v isEnd:isEnd];
    }

}

#pragma mark - BTTHorizontalSlideInsideViewDelegate method
- (void)touchDownOnCheckInButton {
    BTTTaskItem *item = [[BTTTaskItem alloc] init];
    item.taskId = task.taskId;
    item.checked = [NSNumber numberWithInteger:BTT_YES];
    NSDate *now = [NSDate date];
    item.createdTime = now;
    item.updatedTime = now;

    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:self.task.beginTime toDate:now] + 1;
    item.currentDays = [NSNumber numberWithInteger:todayCurrentDays];
    [taskItemDao save:item];

    current.checkInButton.hidden = YES;
    current.checkInLabel.hidden = NO;
    current.checkInLabel.text = NSLocalizedString(@"checked", nil);

    NSArray *weekTaskItemArray = [self loadWeekViewData:now todayCurrentDays:todayCurrentDays];
    [weekView setWeekTaskItemArray:weekTaskItemArray];
}

#pragma mark - BTTGuideViewDelegate
- (void) guideViewDidDisappear{
    BTTFirstBloodViewController *firstBloodViewController = [[BTTFirstBloodViewController alloc] init];
    [self presentViewController:firstBloodViewController animated:NO completion:nil];

}


@end