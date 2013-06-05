//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "BTTHorizontalSlideView.h"

@interface BTTHorizontalSlideView()

@property (strong, nonatomic) UIScrollView *containerScrollView;

@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIView *previousView;
@property (strong, nonatomic) UIView *nextView;

@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation BTTHorizontalSlideView

@synthesize containerScrollView;

@synthesize currentView;
@synthesize previousView;
@synthesize nextView;

@synthesize selectedIndex;

- (id)initWithView:(UIView *)current previous:(UIView *)previous next:(UIView *)next {
    self = [super initWithFrame:self.superview.bounds];

    if (self) {
        currentView = current;
        previousView = previous;
        nextView = next;

        selectedIndex = 0;

        self.frame = CGRectMake(0, 0, 320, 460);

        containerScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        containerScrollView.showsHorizontalScrollIndicator = NO;
        containerScrollView.pagingEnabled = YES;
        [containerScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];

        [self setupViews];
        [self setupRecognizer];

        [self addSubview:containerScrollView];
    }
    return self;
}


- (void)setupViews {
    currentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    previousView.frame = CGRectMake(self.bounds.size.width * -1, 0, self.bounds.size.width, self.bounds.size.height);
    nextView.frame = CGRectMake(self.bounds.size.width * 1, 0, self.bounds.size.width, self.bounds.size.height);
    [containerScrollView addSubview:previousView];
    [containerScrollView addSubview:nextView];
    [containerScrollView addSubview:currentView];
}

- (void)setupRecognizer {
    [self bindRecognizer:currentView];
    [self bindRecognizer:previousView];
    [self bindRecognizer:nextView];
}

- (void)bindRecognizer:(UIView *)bindingView {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewController:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [bindingView addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewController:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [bindingView addGestureRecognizer:swipeRight];
}

- (void)changeViewController:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"111111111");
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        selectedIndex ++;
    } else if (gesture.direction ==  UISwipeGestureRecognizerDirectionRight) {
        selectedIndex --;
    }

    [self slideToView];
}

- (void)slideToView {
    NSLog(@"22222222222");
    UIView *willShowView = currentView;
    if (selectedIndex == -1) {
        willShowView = previousView;
    } else if (selectedIndex == 1) {
        willShowView = nextView;
    }
    CGPoint toPoint = containerScrollView.contentOffset;
    toPoint.x = willShowView.frame.origin.x;

    NSLog(@"x: %.2f", toPoint.x);
    NSLog(@"y: %.2f", toPoint.y);

    [containerScrollView setContentOffset:toPoint animated:YES];
}

- (void)switchView:(UIView *)current previous:(UIView *)previous next:(UIView *)next {


}


@end