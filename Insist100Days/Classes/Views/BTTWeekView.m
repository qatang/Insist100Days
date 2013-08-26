//
// Created by qatang on 13-8-7.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTWeekView.h"
#import "BTTTaskItem.h"
#import "BTTConfig.h"

#define MARGIN_LEFT 20

@interface BTTWeekView()

@property (assign, nonatomic) CGFloat weekDayViewWidth;
@property (assign, nonatomic) CGFloat weekDayViewHeight;
//@property (strong, nonatomic) UIView *sundayView;
//@property (strong, nonatomic) UIView *mondayView;
//@property (strong, nonatomic) UIView *tuesdayView;
//@property (strong, nonatomic) UIView *wednesdayView;
//@property (strong, nonatomic) UIView *thursdayView;
//@property (strong, nonatomic) UIView *fridayView;
//@property (strong, nonatomic) UIView *saturdayView;
//@property (strong, nonatomic) UIImageView *sundayImageView;
//@property (strong, nonatomic) UIImageView *mondayImageView;
//@property (strong, nonatomic) UIImageView *tuesdayImageView;
//@property (strong, nonatomic) UIImageView *wednesdayImageView;
//@property (strong, nonatomic) UIImageView *thursdayImageView;
//@property (strong, nonatomic) UIImageView *fridayImageView;
//@property (strong, nonatomic) UIImageView *saturdayImageView;
@property (strong, nonatomic) NSArray *weekdayViewArray;
@property (strong, nonatomic) NSArray *weekdayImageViewArray;
@property (strong, nonatomic) NSArray *weekdayLabelArray;
@property (strong, nonatomic) NSArray *weekdayTextArray;

@end

@implementation BTTWeekView

@synthesize weekDayViewWidth;
@synthesize weekDayViewHeight;
//@synthesize sundayView;
//@synthesize mondayView;
//@synthesize tuesdayView;
//@synthesize wednesdayView;
//@synthesize thursdayView;
//@synthesize fridayView;
//@synthesize saturdayView;
//@synthesize sundayImageView;
//@synthesize mondayImageView;
//@synthesize tuesdayImageView;
//@synthesize wednesdayImageView;
//@synthesize thursdayImageView;
//@synthesize fridayImageView;
//@synthesize saturdayImageView;
@synthesize weekdayViewArray;
@synthesize weekdayImageViewArray;
@synthesize weekdayLabelArray;
@synthesize weekdayTextArray;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        weekDayViewWidth = floorf((frame.size.width - MARGIN_LEFT * 2) / WEEK_DAYS_COUNT);
        weekDayViewHeight = frame.size.height;

        NSMutableArray *_weekdayTextArray = [[NSMutableArray alloc] init];
        [_weekdayTextArray addObject:NSLocalizedString(@"sunday", nil)];
        [_weekdayTextArray addObject:NSLocalizedString(@"monday", nil)];
        [_weekdayTextArray addObject:NSLocalizedString(@"tuesday", nil)];
        [_weekdayTextArray addObject:NSLocalizedString(@"wednesday", nil)];
        [_weekdayTextArray addObject:NSLocalizedString(@"thursday", nil)];
        [_weekdayTextArray addObject:NSLocalizedString(@"friday", nil)];
        [_weekdayTextArray addObject:NSLocalizedString(@"saturday", nil)];
        weekdayTextArray = _weekdayTextArray;

        [self drawView];
    }
    return self;
}

- (void)drawView {
//    sundayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * SUNDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *sundayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    sundayLabel.text = @"日";
//    sundayLabel.textAlignment = NSTextAlignmentCenter;
//    sundayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    sundayImageView.image = [UIImage imageNamed:@"check_mark"];
//    [sundayView addSubview:sundayLabel];
//    [sundayView addSubview:sundayImageView];
//    [self addSubview:sundayView];
//
//    mondayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * MONDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *mondayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    mondayLabel.text = @"一";
//    mondayLabel.textAlignment = NSTextAlignmentCenter;
//    mondayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    mondayImageView.image = [UIImage imageNamed:@"check_mark"];
//    [mondayView addSubview:mondayLabel];
//    [mondayView addSubview:mondayImageView];
//    [self addSubview:mondayView];
//
//    tuesdayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * TUESDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *tuesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    tuesdayLabel.text = @"二";
//    tuesdayLabel.textAlignment = NSTextAlignmentCenter;
//    tuesdayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    tuesdayImageView.image = [UIImage imageNamed:@"check_mark"];
//    [tuesdayView addSubview:tuesdayLabel];
//    [tuesdayView addSubview:tuesdayImageView];
//    [self addSubview:tuesdayView];
//
//    wednesdayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * WEDNESDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *wednesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    wednesdayLabel.text = @"三";
//    wednesdayLabel.textAlignment = NSTextAlignmentCenter;
//    wednesdayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    wednesdayImageView.image = [UIImage imageNamed:@"check_mark"];
//    [wednesdayView addSubview:wednesdayLabel];
//    [wednesdayView addSubview:wednesdayImageView];
//    [self addSubview:wednesdayView];
//
//    thursdayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * THURSDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *thursdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    thursdayLabel.text = @"四";
//    thursdayLabel.textAlignment = NSTextAlignmentCenter;
//    thursdayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    thursdayImageView.image = [UIImage imageNamed:@"check_mark"];
//    [thursdayView addSubview:thursdayLabel];
//    [thursdayView addSubview:thursdayImageView];
//    [self addSubview:thursdayView];
//
//    fridayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * FRIDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *fridayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    fridayLabel.text = @"五";
//    fridayLabel.textAlignment = NSTextAlignmentCenter;
//    fridayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    fridayImageView.image = [UIImage imageNamed:@"check_mark"];
//    [fridayView addSubview:fridayLabel];
//    [fridayView addSubview:fridayImageView];
//    [self addSubview:fridayView];
//
//    saturdayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * SATURDAY, 0, weekDayViewWidth, weekDayViewHeight)];
//    UILabel *saturdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
//    saturdayLabel.text = @"六";
//    saturdayLabel.textAlignment = NSTextAlignmentCenter;
//    saturdayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
//    saturdayImageView.image = [UIImage imageNamed:@"check_mark"];
////    NSLog(@"%.2f", saturdayImageView.frame.size.width);
////    NSLog(@"%.2f", saturdayImageView.frame.size.height);
//    [saturdayView addSubview:saturdayLabel];
//    [saturdayView addSubview:saturdayImageView];
//    [self addSubview:saturdayView];

    NSMutableArray *_weekdayViewArray = [[NSMutableArray alloc] init];
    NSMutableArray *_weekdayLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *_weekdayImageViewArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < WEEK_DAYS_COUNT; i ++) {
        UIView *weekdayView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + weekDayViewWidth * i, 0, weekDayViewWidth, weekDayViewHeight)];
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, weekDayViewWidth, floorf(weekDayViewHeight / 2))];
        weekdayLabel.text = [weekdayTextArray objectAtIndex:i];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *weekdayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, floorf(weekDayViewHeight / 2), 24, 24)];
        [weekdayView addSubview:weekdayLabel];
        [weekdayView addSubview:weekdayImageView];
        [self addSubview:weekdayView];

        [_weekdayViewArray addObject:weekdayView];
        [_weekdayLabelArray addObject:weekdayLabel];
        [_weekdayImageViewArray addObject:weekdayImageView];
    }

    weekdayViewArray = _weekdayViewArray;
    weekdayLabelArray = _weekdayLabelArray;
    weekdayImageViewArray = _weekdayImageViewArray;
}

- (void)layoutView {
    for (int i = 0; i < weekdayViewArray.count; i ++) {
        BTTTaskItem *taskItem = [_weekTaskItemArray objectAtIndex:i];

        UILabel *weekdayLabel = [weekdayLabelArray objectAtIndex:i];
        UIImageView *weekdayImageView = [weekdayImageViewArray objectAtIndex:i];

        if (taskItem.currentDate) {
            weekdayLabel.textColor = [UIColor redColor];
        } else {
            weekdayLabel.textColor = [UIColor blackColor];
        }

        weekdayImageView.image = nil;
        if (taskItem.in100days) {
            if (taskItem.afterToday) {
                weekdayImageView.image = [UIImage imageNamed:@"warning"];
            } else {
                if (taskItem.checked == [NSNumber numberWithInteger:1]) {
                    weekdayImageView.image = [UIImage imageNamed:@"check_mark"];
                } else {
                    weekdayImageView.image = [UIImage imageNamed:@"cancel"];
                }
            }
        }
    }
}

- (void)setWeekTaskItemArray:(NSArray *)weekTaskItemArray {
    _weekTaskItemArray = weekTaskItemArray;

    [self layoutView];
}

@end