//
// Created by qatang on 13-7-29.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTCreateTaskController.h"
#import "BTTTask.h"
#import "BTTTaskDao.h"
#import "BTTEnums.h"
#import "BTTLogger.h"

#define TASK_TITLE_MAX_LENGTH 10

@interface BTTCreateTaskController()

@property (strong, nonatomic) NSNumber *taskId;
@property (strong, nonatomic) BTTTask *task;
@property (strong, nonatomic) UITextField *titleTextField;

@end

@implementation BTTCreateTaskController

@synthesize taskId;
@synthesize task;
@synthesize titleTextField;

- (id)initWithTaskId:(NSNumber *)tid {
    self = [super init];
    if (self) {
        taskId = tid;
    }
    return self;
}

- (void)setTaskId:(NSNumber *)tid {
    taskId = tid;
}

- (void)setControlValue {
    titleTextField.text = task ? task.title : nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
    if (taskId) {
        task = [taskDao get:taskId];
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];

    [self drawForm];
    [self setControlValue];
}

- (void)viewDidAppear:(BOOL)animated {

    if (taskId) {
        BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
        task = [taskDao get:taskId];
        [self setControlValue];
    }

    [super viewDidAppear:YES];
}

- (void)drawForm {

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = NSLocalizedString(@"task title label", nil);

    UIImage *textFieldImg = [UIImage imageNamed:@"textfield_label_bg"];

    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 20, textFieldImg.size.width, textFieldImg.size.height)];
    titleTextField.background = textFieldImg;
    titleTextField.borderStyle = UITextBorderStyleNone;

    //左侧铅笔
    CGFloat paddingLeft = 6;
    UIView *titleTextFieldLeftView = [[UIView alloc] init];
    UIImage *penImg = [UIImage imageNamed:@"payout_pen"];
    UIImageView *penImgView = [[UIImageView alloc]initWithImage:penImg];
    penImgView.frame = CGRectMake(paddingLeft, 0, penImg.size.width, penImg.size.height);
    titleTextFieldLeftView.frame = CGRectMake(0, 0, penImg.size.width + paddingLeft, penImg.size.height);
    [titleTextFieldLeftView addSubview:penImgView];
    titleTextField.leftView = titleTextFieldLeftView;
    titleTextField.leftView.backgroundColor = [UIColor clearColor];
    titleTextField.leftViewMode = UITextFieldViewModeAlways;

    [titleTextField addTarget:self action:@selector(textFieldDoneEditing) forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.view addSubview:titleLabel];
    [self.view addSubview:titleTextField];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)textFieldDoneEditing {
    [self resignFirstResponder];
}

- (void)save {
    [self dismissKeyboard];

    NSString *title = titleTextField.text;
    if (title == nil || title.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"save failed", nil) message:NSLocalizedString(@"task title warning not null", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"I know it", nil) otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (title.length > TASK_TITLE_MAX_LENGTH) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"save failed", nil) message:NSLocalizedString(@"task title warning too long", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"I know it", nil) otherButtonTitles:nil];
        [alertView show];
        return;
    }

    if (!task) {
        task = [[BTTTask alloc] init];
        task.title = title;
        task.description = nil;
        NSDate *now = [NSDate new];
        task.createdTime = now;
        task.updatedTime = now;
        task.beginTime = now;
        //100天以后
        NSTimeInterval secondsPerDay = 99 * 24 * 60 * 60;
        task.endTime = [now dateByAddingTimeInterval: secondsPerDay];
        //默认为 进行中
        task.status = [[NSNumber alloc] initWithInt:BTT_TASK_DOING];
        task.current = [[NSNumber alloc] initWithUnsignedInteger:BTT_NO];
        task.checkedDays = [[NSNumber alloc] initWithInt:0];
        //第一天
        task.totalDays = [[NSNumber alloc] initWithInt:100];

        BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
        BOOL *result = [taskDao save:task];
        if (!result) {
            BTTLOG_ERROR(@"task save failed!");
            return;
        }
        BTTLOG_INFO(@"task save success!");
    } else {
        task.title = title;
        task.description = nil;
        NSDate *now = [NSDate new];
        task.updatedTime = now;

        BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
        BOOL result = [taskDao update:task];
        if (!result) {
            BTTLOG_ERROR(@"task update failed!");
            return;
        }
        BTTLOG_INFO(@"task update success!");
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightBarButtonItem:(UIButton *)btn {
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchDown];
}

- (BTT_NAVBAR_BACKGROUND_STYLE)styleOfBarBackground {
    return BTT_NAVBAR_BACKGROUND_GRAY;
}

- (BTT_NAVBAR_BUTTON_STYLE)styleOfLeftBarButtonItem {
    return BTT_NAVBAR_BUTTON_RETURN_GRAY;
}

- (NSString *)stringOfLeftBarButtonItem {
    return NSLocalizedString(@"return", nil);
}

- (BOOL)supportBackBarButtonItem {
    return YES;
}


- (BTT_NAVBAR_BUTTON_STYLE)styleOfRightBarButtonItem {
    return BTT_NAVBAR_BUTTON_DONE_GREEN;
}

- (NSString *)stringOfRightBarButtonItem {
    return NSLocalizedString(@"save", nil);
}

- (NSString *)stringOfTitle {
    if (taskId) {
        return NSLocalizedString(@"menu item update task", nil);
    }
    return NSLocalizedString(@"menu item create task", nil);;
}

@end