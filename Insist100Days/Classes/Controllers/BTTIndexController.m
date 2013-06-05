//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "BTTIndexController.h"
#import "BTTHorizontalSlideView.h"


@implementation BTTIndexController {

}

- (void)viewDidLoad {
    NSLog(@"%.2f", self.view.bounds.size.width);
    UIView *current = [[UIView alloc] initWithFrame:self.view.bounds];
    current.backgroundColor = [UIColor grayColor];

    UIView *previous = [[UIView alloc] initWithFrame:self.view.bounds];
    previous.backgroundColor = [UIColor redColor];

    UIView *next = [[UIView alloc] initWithFrame:self.view.bounds];
    next.backgroundColor = [UIColor yellowColor];

    BTTHorizontalSlideView *slideView = [[BTTHorizontalSlideView alloc] initWithView:current previous:previous next:next];

    [self.view addSubview:slideView];
}
@end