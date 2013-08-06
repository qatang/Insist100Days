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
                             currentView.center = previousViewStartCenter;
                             nextView.center = currentViewStartCenter;
//                             previousView.center = nextViewStartCenter;
                             selectedIndex ++;
                             countIndex ++;
                         } else if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
                             currentView.center = nextViewStartCenter;
                             previousView.center = currentViewStartCenter;
//                             nextView.center = previousViewStartCenter;
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

- (void)bindLeftSwipeRecognizer:(UIView *)bindView {
    [self unbindRecognizer:bindView];
    UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [bindView addGestureRecognizer:swipeLeftGestureRecognizer];
}

- (void)bindRightSwipeRecognizer:(UIView *)bindView {
    [self unbindRecognizer:bindView];
    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [bindView addGestureRecognizer:swipeRightGestureRecognizer];
}

- (void)switchView:(UIView *)switchView isEnd:(BOOL)isEnd {
    [self bindRecognizer:switchView];
//    NSLog(@"before current tag : %d", currentView.tag);
//    NSLog(@"before previous tag : %d", previousView.tag);
//    NSLog(@"before next tag : %d", nextView.tag);
//    NSLog(@"switch view tag : %d", switchView.tag);
    if (selectedIndex > 0) {
        previousView = currentView;
        currentView = nextView;
        switchView.center = CGPointMake(self.center.x + self.bounds.size.width, self.center.y);
        nextView = switchView;
        if (isEnd) {
            [self unbindRecognizer:switchView];
            UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            [swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
            [switchView addGestureRecognizer:swipeRightGestureRecognizer];
        }
    } else if (selectedIndex < 0) {
        nextView = currentView;
        currentView = previousView;
        switchView.center = CGPointMake(self.center.x - self.bounds.size.width, self.center.y);
        previousView = switchView;
        if (isEnd) {
            [self unbindRecognizer:switchView];
            UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            [swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
            [switchView addGestureRecognizer:swipeLeftGestureRecognizer];
        }
    }

//    NSLog(@"after current tag : %d", currentView.tag);
//    NSLog(@"after previous tag : %d", previousView.tag);
//    NSLog(@"after next tag : %d", nextView.tag);

    selectedIndex = 0;
}

//#pragma mark - UIGestureRecognizerDelegate method
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}


@end