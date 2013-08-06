//
// Created by qatang on 13-8-5.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTSwitchTaskController.h"
#import "BTTTaskDao.h"
#import "BTTConfig.h"
#import "BTTLogger.h"
#import "BTTEnums.h"

@interface BTTSwitchTaskController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *taskTableView;
@property (strong, nonatomic) NSArray *taskList;

@end

@implementation BTTSwitchTaskController

@synthesize taskTableView;
@synthesize taskList;

- (void)viewDidLoad {
    [super viewDidLoad];

    taskTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;

    [self.view addSubview:taskTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
    [super viewWillAppear:animated];

}

- (void)setTaskList:(NSArray *)bList {
    if (![taskList isEqualToArray:bList]) {
        taskList = bList;
        [self.taskTableView reloadData];
    }
}

- (void)loadData {
    BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
    [self setTaskList:[taskDao list:0 size:DB_LIST_DEFAULT_MAX_PAGE_SIZE]];
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

- (NSString *)stringOfTitle {
    return NSLocalizedString(@"menu item switch task", nil);;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"task cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    BTTTask *task = [self.taskList objectAtIndex:indexPath.row];

    UIImage *checkmark = [UIImage imageNamed:@"check_mark"];
    if (task.current.intValue == BTT_YES) {
        cell.imageView.image = checkmark;
    } else {
        cell.imageView.image = nil;
    }

    cell.textLabel.text = task.title;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTTTask *task = [self.taskList objectAtIndex:indexPath.row];
    if (task.current.intValue == BTT_YES) {
        return;
    }
    BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
    BOOL result = [taskDao setCurrent:task.taskId];
    if (!result) {
        BTTLOG_ERROR(@"task switch failed!");
        return;
    }
    BTTLOG_INFO(@"task switch success!");
    [self setTaskList:[taskDao list:0 size:DB_LIST_DEFAULT_MAX_PAGE_SIZE]];
}

@end