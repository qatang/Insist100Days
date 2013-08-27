//
// Created by qatang on 13-8-27.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTStatisticsTaskController.h"
#import "BTTTaskDao.h"
#import "BTTConfig.h"
#import "BTTStatisticsDetailCellView.h"
#import "BTTDateUtil.h"

#define TABLE_ROW_HEIGHT 60

@interface BTTStatisticsTaskController()

@property (strong, nonatomic) UITableView *taskTableView;
@property (strong, nonatomic) NSArray *taskList;

@end

@implementation BTTStatisticsTaskController

@synthesize taskTableView;
@synthesize taskList;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];

    taskTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    taskTableView.delegate = self;
    taskTableView.dataSource = self;
    taskTableView.rowHeight = TABLE_ROW_HEIGHT;

    [self.view addSubview:taskTableView];
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StatisticsDetailCell";

    BTTStatisticsDetailCellView *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BTTStatisticsDetailCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    BTTTask *task = [taskList objectAtIndex:indexPath.row];
    cell.height = TABLE_ROW_HEIGHT;

    NSDate *now = [NSDate date];
    NSInteger todayCurrentDays = [BTTDateUtil daysBetweenTwoDatesByEra:task.beginTime toDate:now] + 1;

    [cell setTask:task currentDays:todayCurrentDays > BTT_INSIST_DAYS_COUNT ? BTT_INSIST_DAYS_COUNT : todayCurrentDays];

    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_ROW_HEIGHT;
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
    return NSLocalizedString(@"menu item statistics", nil);;
}

@end