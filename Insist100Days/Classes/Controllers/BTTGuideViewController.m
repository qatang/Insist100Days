//
//  BTTGuideViewController.m
//  Insist100Days
//
//  Created by leiming on 13-8-30.
//  Copyright (c) 2013年 leiming. All rights reserved.
//

#import "BTTGuideViewController.h"
#import "KxIntroViewPage.h"
#import "KxIntroView.h"
#import "BTTConfig.h"
#import "BTTFirstBloodViewController.h"

@interface BTTGuideViewController () <KxIntroViewDelegate>

@end

@implementation BTTGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCustom{
    self = [super initWithPages:[self buildPages]];
    if (self) {
        [self buildGuide];
    }
    return self;
}

- (NSArray *) buildPages{
    KxIntroViewPage *page0 = [KxIntroViewPage introViewPageWithTitle: @"挑战自己"
                                                          withDetail: @"坚持一百天就是胜利！"
                                                           withImage: [UIImage imageNamed:@"sun"]];
    
    KxIntroViewPage *page1 = [KxIntroViewPage introViewPageWithTitle: @"我的目标"
                                                          withDetail: @"我的坚持\n\n- 不抽烟\n- 不喝酒\n- 不打游戏\n- feature #4\n- feature #5"
                                                           withImage: [UIImage imageNamed:@"tor"]];
    
    KxIntroViewPage *page2 = [KxIntroViewPage introViewPageWithTitle: @"Lorem Ipsum passage"
                                                          withDetail: @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip lex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum!"
                                                           withImage: nil];
    
    page1.detailLabel.textAlignment = NSTextAlignmentLeft;
    NSArray *pages = @[page0, page1, page2];
    return pages;
    
}
- (void) buildGuide{
    self.introView.animatePageChanges = YES;
    self.introView.gradientBackground = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KxIntroViewDelegate

- (void)introView:(KxIntroView *)view didComplete:(BOOL)finished{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:NO];
    } else if (self.view.superview) {
        if (!finished) {
            
            [UIView animateWithDuration:0.2
                             animations:^
             {
                 self.view.alpha = 0;
             }
                             completion:^(BOOL finished)
             {
                 [self.view removeFromSuperview];
             }];
            
        } else {
            [self.view removeFromSuperview];
        }
    }
    
    if ([self.guideViewDelegate respondsToSelector:@selector(guideViewDidDisappear)]) {
        [self.guideViewDelegate guideViewDidDisappear];
    }
    
    
}

@end
