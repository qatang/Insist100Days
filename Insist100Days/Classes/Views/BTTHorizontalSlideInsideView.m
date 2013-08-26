//
// Created by qatang on 13-8-26.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTHorizontalSlideInsideView.h"


@implementation BTTHorizontalSlideInsideView

@synthesize delegate;
@synthesize dateLabel;
@synthesize countLabel;
@synthesize checkInLabel;
@synthesize checkInButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawForm];
    }
    return self;
}

- (void)drawForm {
    UILabel *currentDateStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 80, 30)];
    currentDateStringLabel.textAlignment = NSTextAlignmentRight;
    currentDateStringLabel.text = NSLocalizedString(@"date", nil);

    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 200, 30)];
    dateLabel.textColor = [UIColor redColor];
    dateLabel.textAlignment = NSTextAlignmentLeft;

    UILabel *currentCountStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    currentCountStringLabel.textAlignment = NSTextAlignmentRight;
    currentCountStringLabel.text = NSLocalizedString(@"days", nil);

    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    countLabel.textColor = [UIColor redColor];
    countLabel.textAlignment = NSTextAlignmentLeft;

    checkInButton = [[UIButton alloc] initWithFrame:CGRectMake(100, self.bounds.size.height - 40, 100, 30)];
    [checkInButton setTitle:NSLocalizedString(@"checkin", nil) forState:UIControlStateNormal];
    checkInButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    checkInButton.backgroundColor = [UIColor redColor];
    [checkInButton addTarget:self action:@selector(checkIn) forControlEvents:UIControlEventTouchDown];

    checkInLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.bounds.size.height - 40, 100, 30)];
    checkInLabel.textAlignment = NSTextAlignmentCenter;
    checkInLabel.font = [UIFont boldSystemFontOfSize:14];

    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:dateLabel];
    [self addSubview:countLabel];
    [self addSubview:currentDateStringLabel];
    [self addSubview:currentCountStringLabel];
    [self addSubview:checkInButton];
    [self addSubview:checkInLabel];
}

- (void)checkIn {
    [delegate touchDownOnCheckInButton];
}

@end