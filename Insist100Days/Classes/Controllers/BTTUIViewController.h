//
// Created by qatang on 13-7-29.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BTT_NAVBAR_BACKGROUND_STYLE)
{
    BTT_NAVBAR_BACKGROUND_NONE = 0,

    BTT_NAVBAR_BACKGROUND_GREEN,
    BTT_NAVBAR_BACKGROUND_GRAY,
};

typedef NS_ENUM(NSUInteger, BTT_NAVBAR_BUTTON_STYLE)
{
    BTT_NAVBAR_BUTTON_NONE = 0,

    BTT_NAVBAR_BUTTON_MENU,
    BTT_NAVBAR_BUTTON_EDIT,

    BTT_NAVBAR_BUTTON_RETURN_GREEN,
    BTT_NAVBAR_BUTTON_DONE_GREEN,

    BTT_NAVBAR_BUTTON_RETURN_GRAY,
};

#define NAVBAR_BUTTON_TITLE_FONT_SIZE 12

@protocol BTTUIViewControllerDelegate <NSObject>

@optional

- (BTT_NAVBAR_BACKGROUND_STYLE)styleOfBarBackground;

- (BTT_NAVBAR_BUTTON_STYLE)styleOfLeftBarButtonItem;

- (NSString *)stringOfLeftBarButtonItem;

- (void)leftBarButtonItem:(UIButton *)btn;

- (BTT_NAVBAR_BUTTON_STYLE)styleOfRightBarButtonItem;

- (NSString *)stringOfRightBarButtonItem;

- (void)rightBarButtonItem:(UIButton *)btn;

- (BOOL)supportBackBarButtonItem;

- (NSString *)stringOfTitle;

- (UIView *)customViewOfTitle;

@required

- (CGFloat)minimumBarButtonWidth;

@end

@interface BTTUIViewController : UIViewController <BTTUIViewControllerDelegate>

@property (nonatomic, weak) id<BTTUIViewControllerDelegate> delegate;

@end