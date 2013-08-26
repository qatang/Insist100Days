//
// Created by qatang on 13-8-26.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol BTTHorizontalSlideInsideViewDelegate

- (void)touchDownOnCheckInButton;

@end

@interface BTTHorizontalSlideInsideView : UIView

@property (weak, nonatomic) id<BTTHorizontalSlideInsideViewDelegate> delegate;

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UILabel *checkInLabel;
@property (strong, nonatomic) UIButton *checkInButton;

@end