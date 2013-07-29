//
// Created by qatang on 13-7-29.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTListTaskController.h"
#import "BTTTaskDao.h"
#import "BTTConfig.h"
#import "BTTCreateTaskController.h"
#import "BTTLogger.h"

@interface BTTListTaskController() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *taskTableView;
@property (strong, nonatomic) NSArray *taskList;

@end

@implementation BTTListTaskController

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
    return NSLocalizedString(@"menu item my tasks", nil);;
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
    cell.textLabel.text = task.title;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTTTask *task = [self.taskList objectAtIndex:indexPath.row];

    BTTCreateTaskController *createTaskController = [[BTTCreateTaskController alloc] initWithTaskId:task.taskId];
    [self.navigationController pushViewController:createTaskController animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BTTTask *b = [taskList objectAtIndex:indexPath.row];
        BTTTaskDao *taskDao = [[BTTTaskDao alloc] init];
        BOOL result = [taskDao del:b];
        if (!result) {
            BTTLOG_INFO(@"task delete failure!");
        }
        [self loadData];
    }
}

@end