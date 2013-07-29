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

@interface BTTIndexController()

@property (strong, nonatomic) UIView *current;
@property (strong, nonatomic) UIView *previous;
@property (strong, nonatomic) UIView *next;

@property (strong, nonatomic) UILabel *currentLabel;
@property (strong, nonatomic) UILabel *previousLabel;
@property (strong, nonatomic) UILabel *nextLabel;

@property (strong, nonatomic) NSArray *viewArray;

@property (strong, nonatomic) BTTHorizontalSlideView *slideView;

@end

@implementation BTTIndexController

@synthesize current;
@synthesize previous;
@synthesize next;

@synthesize currentLabel;
@synthesize previousLabel;
@synthesize nextLabel;

@synthesize viewArray;

@synthesize slideView;

- (void)viewDidLoad {
//    NSLog(@"%.2f", self.view.bounds.size.width);
    UIView *topView = [self.view.subviews objectAtIndex:0];
    topView.backgroundColor = [UIColor redColor];

    UIView *middleView = [self.view.subviews objectAtIndex:1];
    UIView *middleMainView = [middleView.subviews objectAtIndex:0];

    UIView *middleBottomView = [middleView.subviews objectAtIndex:1];
    UIButton *middleBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 13, 24, 24)];
    [middleBottomButton setBackgroundImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    [middleBottomButton addTarget:self action:@selector(gotoSetup) forControlEvents:UIControlEventTouchDown];
    [middleBottomView addSubview:middleBottomButton];

    NSDate *now = [NSDate new];

    currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 240, 30)];
    currentLabel.textColor = [UIColor redColor];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:now];
    current = [[UIView alloc] initWithFrame:middleMainView.bounds];
    current.backgroundColor = [UIColor whiteColor];
    current.tag = 0;
    [current addSubview:currentLabel];

    NSTimeInterval yesterdayInterval = 24 * 60 * 60 * -1;
    NSDate *yesterday = [now initWithTimeIntervalSinceNow:yesterdayInterval];
    previousLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 240, 30)];
    previousLabel.textColor = [UIColor brownColor];
    previousLabel.textAlignment = NSTextAlignmentCenter;
    previousLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:yesterday];
    previous = [[UIView alloc] initWithFrame:middleMainView.bounds];
    previous.backgroundColor = [UIColor whiteColor];
    previous.tag = -1;
    [previous addSubview:previousLabel];

    NSTimeInterval tomorrowInterval = 24 * 60 * 60 * 1;
    NSDate *tomorrow = [now initWithTimeIntervalSinceNow:tomorrowInterval];
    nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 240, 30)];
    nextLabel.textColor = [UIColor blueColor];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    nextLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:tomorrow];
    next = [[UIView alloc] initWithFrame:middleMainView.bounds];
    next.backgroundColor = [UIColor whiteColor];
    next.tag = 1;
    [next addSubview:nextLabel];

    viewArray = [[NSArray alloc] initWithObjects:previous, current, next, nil];

    slideView = [[BTTHorizontalSlideView alloc] initWithView:current previous:previous next:next frame:middleMainView.bounds];
    slideView.delegate = self;

    [middleMainView addSubview:slideView];
}

- (void)gotoSetup {
    BTTSetupController *setupController = [[BTTSetupController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setupController];

    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - BTTHorizontalSlideViewDelegate method
- (void)setupViewData:(NSInteger)selectedIndex countIndex:(NSInteger)countIndex {
    NSDate *now = [NSDate new];
//    NSTimeInterval currentInterval = 24 * 60 * 60 * countIndex;
    NSTimeInterval previousInterval = 24 * 60 * 60 * (countIndex - 1);
    NSTimeInterval nextInterval = 24 * 60 * 60 * (countIndex + 1);
//    NSDate *currentDate = [now initWithTimeIntervalSinceNow:currentInterval];
    NSDate *previousDate = [now initWithTimeIntervalSinceNow:previousInterval];
    NSDate *nextDate = [now initWithTimeIntervalSinceNow:nextInterval];

    if (selectedIndex > 0) {

        NSMutableArray *viewArrayTmp = [NSMutableArray array];
        [viewArrayTmp addObject:[viewArray objectAtIndex:1]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:2]];
        [viewArrayTmp addObject:[viewArray objectAtIndex:0]];
        viewArray = viewArrayTmp;

        UIView *v = viewArray.lastObject;
        if (v.tag > 0) {
            nextLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
        } else if (v.tag < 0) {
            previousLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
        } else {
            currentLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
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
            nextLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
        } else if (v.tag < 0) {
            previousLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
        } else {
            currentLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
        }

        [slideView switchView:v];
    }

}

@end