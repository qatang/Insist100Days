//
// Created by qatang on 13-7-29.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BTTUIViewController.h"

@implementation BTTUIViewController {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // 设置导航背景样式
    [self setBarBackground];

    // 设置Title
    [self setBarTitle];

    // 设置左导航
    [self setLeftBarButtonItem];

    // 设置右导航
    [self setRightBarButtonItem];
}


- (UIButton *)createBarButton:(BTT_NAVBAR_BUTTON_STYLE)styleOfButton title:(NSString *)title originalButton:(UIButton *)originalButton {
    UIButton *btn = originalButton;
    if (!btn) {
        btn = [[UIButton alloc] init];
    }
    switch (styleOfButton) {
        case BTT_NAVBAR_BUTTON_MENU: {
            UIImage *btnImage = [UIImage imageNamed:@"navbar-button-menu.png"];
            [btn setImage:btnImage forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
            break;
        }
        case BTT_NAVBAR_BUTTON_EDIT: {
            UIImage *btnImage = [UIImage imageNamed:@"navbar-button-edit.png"];
            [btn setImage:btnImage forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
            break;
        }
        case BTT_NAVBAR_BUTTON_RETURN_GREEN: {
            UIImage *btnImage = [[UIImage imageNamed:@"navbar-button-return-green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5)];
            [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
            if (title) {
                [btn setTitle:title forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:NAVBAR_BUTTON_TITLE_FONT_SIZE];
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);

                CGSize sizeOfTitle = [title sizeWithFont:[UIFont boldSystemFontOfSize:NAVBAR_BUTTON_TITLE_FONT_SIZE]];
                btn.frame = CGRectMake(0, 0, MAX(self.delegate.minimumBarButtonWidth, sizeOfTitle.width) + 15, btnImage.size.height);
            } else {
                btn.frame = CGRectMake(0, 0, self.delegate.minimumBarButtonWidth + 15, btnImage.size.height);
            }
            break;
        }
        case BTT_NAVBAR_BUTTON_DONE_GREEN: {
            UIImage *btnImage = [[UIImage imageNamed:@"navbar-button-done-green.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
            [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
            if (title) {
                [btn setTitle:title forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:NAVBAR_BUTTON_TITLE_FONT_SIZE];
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);

                CGSize sizeOfTitle = [title sizeWithFont:[UIFont boldSystemFontOfSize:NAVBAR_BUTTON_TITLE_FONT_SIZE]];
                btn.frame = CGRectMake(0, 0, MAX(self.delegate.minimumBarButtonWidth, sizeOfTitle.width) + 10, btnImage.size.height);
            } else {
                btn.frame = CGRectMake(0, 0, self.delegate.minimumBarButtonWidth + 10, btnImage.size.height);
            }
            break;
        }
        case BTT_NAVBAR_BUTTON_RETURN_GRAY: {
            UIImage *btnImage = [[UIImage imageNamed:@"navbar-button-return-gray.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 5)];
            [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
            if (title) {
                [btn setTitle:title forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:NAVBAR_BUTTON_TITLE_FONT_SIZE];
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 5);

                CGSize sizeOfTitle = [title sizeWithFont:[UIFont boldSystemFontOfSize:NAVBAR_BUTTON_TITLE_FONT_SIZE]];
                btn.frame = CGRectMake(0, 0, MAX(self.delegate.minimumBarButtonWidth, sizeOfTitle.width) + 15, btnImage.size.height);
            } else {
                btn.frame = CGRectMake(0, 0, self.delegate.minimumBarButtonWidth + 15, btnImage.size.height);
            }
            break;
        }
        default: {
            return nil;
        }
    }

    return btn;
}

- (void)setLeftBarButtonItem {
    if ([self.delegate respondsToSelector:@selector(styleOfLeftBarButtonItem)]) {
        // 设置样式
        BTT_NAVBAR_BUTTON_STYLE styleOfButton = [self.delegate styleOfLeftBarButtonItem];

        if (styleOfButton == BTT_NAVBAR_BUTTON_NONE) {
            if (self.navigationItem.leftBarButtonItem) {
                self.navigationItem.leftBarButtonItem = nil;
            }
            self.navigationItem.hidesBackButton = YES;
            return;
        }

        NSString *title = nil;
        if ([self.delegate respondsToSelector:@selector(stringOfLeftBarButtonItem)]) {
            title = [self.delegate stringOfLeftBarButtonItem];
        }

        UIButton *originalButton = nil;

        if (self.navigationItem.leftBarButtonItem.customView && [self.navigationItem.leftBarButtonItem.customView isKindOfClass:[UIButton class]]) {
            originalButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        }

        UIButton *btn = [self createBarButton:styleOfButton title:title originalButton:originalButton];
        if (btn) {
            if ([self.delegate respondsToSelector:@selector(leftBarButtonItem:)]) {
                [self.delegate performSelector:@selector(leftBarButtonItem:) withObject:btn];
            }
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        }
    }
}

- (void)setRightBarButtonItem {
    if ([self.delegate respondsToSelector:@selector(styleOfRightBarButtonItem)]) {
        // 设置样式
        BTT_NAVBAR_BUTTON_STYLE styleOfButton = [self.delegate styleOfRightBarButtonItem];

        if (styleOfButton == BTT_NAVBAR_BUTTON_NONE) {
            if (self.navigationItem.rightBarButtonItem) {
                self.navigationItem.rightBarButtonItem = nil;
            }
            return;
        }

        NSString *title = nil;
        if ([self.delegate respondsToSelector:@selector(stringOfRightBarButtonItem)]) {
            title = [self.delegate stringOfRightBarButtonItem];
        }

        UIButton *originalButton = nil;

        if (self.navigationItem.rightBarButtonItem.customView && [self.navigationItem.rightBarButtonItem.customView isKindOfClass:[UIButton class]]) {
            originalButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
        }

        UIButton *btn = [self createBarButton:styleOfButton title:title originalButton:originalButton];
        if (btn) {
            if ([self.delegate respondsToSelector:@selector(rightBarButtonItem:)]) {
                [self.delegate performSelector:@selector(rightBarButtonItem:) withObject:btn];
            }
            if (self.navigationItem.rightBarButtonItem) {
                self.navigationItem.rightBarButtonItem.customView = btn;
            } else {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
            }
        }
    }
}

- (void)setBarBackground {
    if ([self.delegate respondsToSelector:@selector(styleOfBarBackground)]) {
        if ([self.delegate styleOfBarBackground] != BTT_NAVBAR_BACKGROUND_NONE) {
            NSString *backgroundImageName = nil;
            switch ([self.delegate styleOfBarBackground]) {
                case BTT_NAVBAR_BACKGROUND_GREEN: {
                    backgroundImageName = @"navbar-background-green.png";
                    break;
                }
                case BTT_NAVBAR_BACKGROUND_GRAY: {
                    backgroundImageName = @"navbar-background-gray.png";
                    break;
                }
                default: {
                    break;
                }
            }

            if (backgroundImageName) {
                UIImage *navbarPortrait = [[UIImage imageNamed:backgroundImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                [self.navigationController.navigationBar setBackgroundImage:navbarPortrait forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
}

- (void)setBarTitle {
    // 是否启用了自定义视图
    if ([self.delegate respondsToSelector:@selector(customViewOfTitle)] && [self.delegate customViewOfTitle]) {
        self.navigationItem.titleView = [self.delegate customViewOfTitle];
    } else {
        if ([self.delegate respondsToSelector:@selector(stringOfTitle)]) {
            self.navigationItem.title = [self.delegate stringOfTitle];
        }
    }
}

#pragma mark -- BTTUIViewControllerDelegate
- (CGFloat)minimumBarButtonWidth {
    return 32;
}

- (BTT_NAVBAR_BACKGROUND_STYLE)styleOfBarBackground {
    return BTT_NAVBAR_BACKGROUND_GREEN;
}

- (NSString *)stringOfLeftBarButtonItem {
    // 兼容后退按钮
    if ([self.delegate respondsToSelector:@selector(supportBackBarButtonItem)]) {
        BOOL supportBackBarButtonItem = [self supportBackBarButtonItem];
        if (supportBackBarButtonItem && [self.navigationController.viewControllers count] >= 2) {
            // 自动设置按钮文本为上一controller的标题
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
            return viewController.navigationItem.title;
        }
    }
    return nil;
}


- (void)defaultActionOfBackBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftBarButtonItem:(UIButton *)btn {
    if (self.navigationItem.leftBarButtonItem && !self.navigationItem.leftBarButtonItem.customView) {
        [btn addTarget:self.navigationItem.leftBarButtonItem.target action:self.navigationItem.leftBarButtonItem.action forControlEvents:UIControlEventTouchUpInside];
    } else {
        // 兼容后退按钮
        if ([self.delegate respondsToSelector:@selector(supportBackBarButtonItem)]) {
            BOOL supportBackBarButtonItem = [self supportBackBarButtonItem];
            if (supportBackBarButtonItem) {
                [btn addTarget:self.delegate action:@selector(defaultActionOfBackBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)rightBarButtonItem:(UIButton *)btn {
    if (self.navigationItem.rightBarButtonItem && !self.navigationItem.rightBarButtonItem.customView) {
        [btn addTarget:self.navigationItem.rightBarButtonItem.target action:self.navigationItem.rightBarButtonItem.action forControlEvents:UIControlEventTouchUpInside];
    }
}


@end