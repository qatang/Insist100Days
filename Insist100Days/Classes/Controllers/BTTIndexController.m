//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTIndexController.h"
#import "BTTHorizontalSlideView.h"
#import "BTTDateUtil.h"

@interface BTTIndexController()

@property (strong, nonatomic) UIView *current;
@property (strong, nonatomic) UIView *previous;
@property (strong, nonatomic) UIView *next;

@property (strong, nonatomic) UILabel *currentLabel;
@property (strong, nonatomic) UILabel *previousLabel;
@property (strong, nonatomic) UILabel *nextLabel;

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) BTTHorizontalSlideView *slideView;

@end

@implementation BTTIndexController

@synthesize current;
@synthesize previous;
@synthesize next;

@synthesize currentLabel;
@synthesize previousLabel;
@synthesize nextLabel;

@synthesize array;

@synthesize slideView;

- (void)viewDidLoad {
//    NSLog(@"%.2f", self.view.bounds.size.width);
    NSDate *now = [NSDate new];

    currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 240, 30)];
//    currentLabel.textColor = [UIColor redColor];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:now];
    current = [[UIView alloc] initWithFrame:self.view.bounds];
    current.backgroundColor = [UIColor whiteColor];
    [current addSubview:currentLabel];

    NSTimeInterval yesterdayInterval = 24 * 60 * 60 * -1;
    NSDate *yesterday = [now initWithTimeIntervalSinceNow:yesterdayInterval];
    previousLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 240, 30)];
//    previousLabel.textColor = [UIColor yellowColor];
    previousLabel.textAlignment = NSTextAlignmentCenter;
    previousLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:yesterday];
    previous = [[UIView alloc] initWithFrame:self.view.bounds];
    previous.backgroundColor = [UIColor whiteColor];
    [previous addSubview:previousLabel];

    NSTimeInterval tomorrowInterval = 24 * 60 * 60 * 1;
    NSDate *tomorrow = [now initWithTimeIntervalSinceNow:tomorrowInterval];
    nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 100, 240, 30)];
//    nextLabel.textColor = [UIColor blueColor];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    nextLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:tomorrow];
    next = [[UIView alloc] initWithFrame:self.view.bounds];
    next.backgroundColor = [UIColor whiteColor];
    [next addSubview:nextLabel];

    CGRect slideViewFrame = CGRectMake(0, 0, 320, 460);

    slideView = [[BTTHorizontalSlideView alloc] initWithView:current previous:previous next:next frame:slideViewFrame];
    slideView.delegate = self;
    [self.view addSubview:slideView];
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
    if (selectedIndex > 0) {
        currentLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
        previousLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
        nextLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:currentDate];
        [slideView switchView:next previous:current next:previous];
    } else if (selectedIndex < 0) {
        currentLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:nextDate];
        previousLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:currentDate];
        nextLabel.text = [BTTDateUtil convertDateToDateStringByDefaultPattern:previousDate];
        [slideView switchView:previous previous:next next:current];
    }

}

@end