//
//  BTTGuideViewController.h
//  Insist100Days
//
//  Created by leiming on 13-8-30.
//  Copyright (c) 2013年 leiming. All rights reserved.
//

#import "KxIntroViewController.h"

@protocol BTTGuideViewDelegate <NSObject>

- (void)guideViewDidDisappear;

@end

@interface BTTGuideViewController : KxIntroViewController

- (id)initWithCustom;

@property (nonatomic, weak) id<BTTGuideViewDelegate> guideViewDelegate;

@end
