//
// Created by qatang on 13-6-4.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface BTTHorizontalSlideView : UIView

- initWithView:(UIView *)current previous:(UIView *)previous next:(UIView *)next;

- (void)switchView:(UIView *)current previous:(UIView *)previous next:(UIView *)next;

@end