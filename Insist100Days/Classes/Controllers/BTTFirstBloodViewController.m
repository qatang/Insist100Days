//
//  BTTFirstBloodViewController.m
//  Insist100Days
//
//  Created by leiming on 13-8-30.
//  Copyright (c) 2013年 leiming. All rights reserved.
//

#import "BTTFirstBloodViewController.h"
#import "BTTTask.h"
#import "BTTConfig.h"
#import "BTTTaskDao.h"
#import "BTTEnums.h"
#import "BTTLogger.h"
#import <QuartzCore/QuartzCore.h>

#define TASK_TITLE_MAX_LENGTH 10

@interface BTTFirstBloodViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *titleTextField;

@end

@implementation BTTFirstBloodViewController

@synthesize titleTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self drawForm];
}

- (void)drawForm{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 80, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = NSLocalizedString(@"task title label", nil);
    
    UIImage *textFieldImg = [UIImage imageNamed:@"textfield_label_bg"];
    
    titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 50, textFieldImg.size.width, textFieldImg.size.height)];
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
    
    CGSize buttonSize = CGSizeMake(100, 30);
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-buttonSize.width/2, 90, buttonSize.width, buttonSize.height)];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchDown];
    [saveButton setTitle:NSLocalizedString(@"start task", nil) forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setBackgroundColor:[UIColor redColor]];
    saveButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];

    [self.view addSubview:titleLabel];
    [self.view addSubview:titleTextField];
    [self.view addSubview:saveButton];

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
    
    BTTTask *task = [[BTTTask alloc] init];
    task.title = title;
    task.description = nil;
    NSDate *now = [NSDate new];
    task.createdTime = now;
    task.updatedTime = now;
    task.beginTime = now;
    //100天以后
    NSTimeInterval secondsPerDay = (BTT_INSIST_DAYS_COUNT - 1) * PER_DAY_INTERVAL;
    task.endTime = [now dateByAddingTimeInterval: secondsPerDay];
    //默认为 进行中
    task.status = [[NSNumber alloc] initWithInt:BTT_TASK_DOING];
    task.current = [[NSNumber alloc] initWithUnsignedInteger:BTT_NO];
    task.checkedDays = [[NSNumber alloc] initWithInt:0];
    task.totalDays = [[NSNumber alloc] initWithInt:BTT_INSIST_DAYS_COUNT];
    
    BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
    BOOL result = [taskDao save:task];
    if (!result) {
        BTTLOG_ERROR(@"task save failed!");
        return;
    }
    BTTLOG_INFO(@"task save success!");
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:KEY_HAS_CREATED_TASK]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KEY_HAS_CREATED_TASK];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // 自己消失
    CATransition *animation = [CATransition animation];//初始化动画
    animation.duration = 0.3;//间隔的时间
    
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    animation.type = kCATransitionPush;
    animation.delegate = self;
    
    //设置动画的方向
    animation.subtype = kCATransitionFromRight;
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    self.view.alpha = 0;

    [self dismissViewControllerAnimated:YES completion:nil];
    [UIView commitAnimations];

    
    // 显示状态栏
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO withAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
