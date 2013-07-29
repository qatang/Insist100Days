//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol BTTHorizontalSlideViewDelegate

- (void)setupViewData:(NSInteger)selectedIndex countIndex:(NSInteger)countIndex;

@end

@interface BTTHorizontalSlideView : UIView

@property (strong, nonatomic) id<BTTHorizontalSlideViewDelegate> delegate;

- initWithView:(UIView *)current previous:(UIView *)previous next:(UIView *)next frame:(CGRect)frame;

- (void)switchView:(UIView *)switchView;

@end