//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTHorizontalSlideView.h"

@interface BTTHorizontalSlideView()

@property (strong, nonatomic) UIView *currentView;
@property (strong, nonatomic) UIView *previousView;
@property (strong, nonatomic) UIView *nextView;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSInteger countIndex;

@property (nonatomic) CGPoint currentViewStartCenter;
@property (nonatomic) CGPoint previousViewStartCenter;
@property (nonatomic) CGPoint nextViewStartCenter;

@end

@implementation BTTHorizontalSlideView

@synthesize delegate;

@synthesize currentView;
@synthesize previousView;
@synthesize nextView;

@synthesize selectedIndex;
@synthesize countIndex;

@synthesize currentViewStartCenter;
@synthesize previousViewStartCenter;
@synthesize nextViewStartCenter;

- (id)initWithView:(UIView *)current previous:(UIView *)previous next:(UIView *)next frame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        currentView = current;
        previousView = previous;
        nextView = next;

        selectedIndex = 0;
        countIndex = 0;

        [self setupViews];
        [self setupRecognizer];

    }
    return self;
}


- (void)setupViews {
    currentView.center = self.center;
    previousView.center = CGPointMake(self.center.x - self.bounds.size.width, self.center.y);
    nextView.center = CGPointMake(self.center.x + self.bounds.size.width, self.center.y);

    currentViewStartCenter = currentView.center;
    previousViewStartCenter = previousView.center;
    nextViewStartCenter = nextView.center;

    [self addSubview:previousView];
    [self addSubview:nextView];
    [self addSubview:currentView];
}

- (void)setupRecognizer {
    [self bindRecognizer:currentView];
    [self bindRecognizer:previousView];
    [self bindRecognizer:nextView];
}

- (void)bindRecognizer:(UIView *)bindingView {
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    panGestureRecognizer.delegate = self;
//    [bindingView addGestureRecognizer:panGestureRecognizer];

    UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
//    swipeLeftGestureRecognizer.delegate = self;
//    [swipeLeftGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
    [bindingView addGestureRecognizer:swipeLeftGestureRecognizer];

    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    swipeRightGestureRecognizer.delegate = self;
//    [swipeRightGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
    [bindingView addGestureRecognizer:swipeRightGestureRecognizer];

}

- (void)unbindRecognizer:(UIView *)unbindingView {
    NSArray *gestureRecognizerArray = [unbindingView gestureRecognizers];
    for (UIGestureRecognizer *gestureRecognizer in gestureRecognizerArray) {
        [unbindingView removeGestureRecognizer:gestureRecognizer];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
                             nextView.center = currentViewStartCenter;
                             currentView.center = previousViewStartCenter;
                             previousView.center = nextViewStartCenter;
                             selectedIndex ++;
                             countIndex ++;
                         } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
                             previousView.center = currentViewStartCenter;
                             currentView.center = nextViewStartCenter;
                             nextView.center = previousViewStartCenter;
                             selectedIndex --;
                             countIndex --;
                         }
                     }
                     completion:^(BOOL finished){
                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
                         [self.delegate setupViewData:selectedIndex countIndex:countIndex];
                     }];
}

//- (void)handlePan:(UIPanGestureRecognizer *)gesture
//{
////    NSLog(@"111111111");
//    CGPoint translatedPoint = [gesture translationInView:[gesture view]];
////    NSLog(@"%.2f", translatedPoint.x);
////    NSLog(@"%.2f", ABS(translatedPoint.x));
////    CGPoint velocityPoint = [gesture velocityInView:[gesture view]];
////    NSLog(@"velocityPointX : %.2f", velocityPoint.x);
////    NSLog(@"velocityPointY : %.2f", velocityPoint.y);
//
//    if ([gesture state] == UIGestureRecognizerStateBegan) {
//
//    }
//
//
//    NSLog(@"pan change");
//    currentView.center = CGPointMake(currentViewStartCenter.x + translatedPoint.x, currentViewStartCenter.y);
//    previousView.center = CGPointMake(previousViewStartCenter.x + translatedPoint.x, previousViewStartCenter.y);
//    nextView.center = CGPointMake(nextViewStartCenter.x + translatedPoint.x, nextViewStartCenter.y);
//
//    if ([gesture state] == UIGestureRecognizerStateEnded) {
////        NSLog(@"%.2f", panDistance);
//    }
//
//}

- (void)switchView:(UIView *)current previous:(UIView *)previous next:(UIView *)next {
    [self unbindRecognizer:currentView];
    [self unbindRecognizer:previousView];
    [self unbindRecognizer:nextView];

    currentView = current;
    previousView = previous;
    nextView = next;

    selectedIndex = 0;

    [self setupViews];
    [self setupRecognizer];
}

//#pragma mark - UIGestureRecognizerDelegate method
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}


@end