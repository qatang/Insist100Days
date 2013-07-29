//
// Created by qatang on 13-6-20.
// Copyright (c) 2013 ___FULLUSERNAME___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BTTSetupController.h"
#import "BTTCreateTaskController.h"
#import "BTTListTaskController.h"

#define MENU_ITEM_HEIGHT 55

typedef NS_ENUM(NSUInteger, BTT_MENU_ITEM_INDEX)
{
    BTT_MENU_ITEM_CREATE_TASK = 0,
    BTT_MENU_ITEM_MYTASK,
    BTT_MENU_ITEM_STATISTICS,
    BTT_MENU_ITEM_COUNT
};

@implementation BTTSetupController {
    NSArray *menuItemNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITableView *tableView = [self.view.subviews objectAtIndex:0];

    menuItemNames = [[NSArray alloc] initWithObjects:
            NSLocalizedString(@"menu item create task", nil),
            NSLocalizedString(@"menu item my tasks", nil),
            NSLocalizedString(@"menu item statistics", nil),
            nil];
//    UIButton *rightBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 18)];
//    [rightBarButton setTitle:NSLocalizedString(@"return", nil) forState:UIControlStateNormal];
//    [rightBarButton addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchDown];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"return", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dismissController)];
//    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView data source and delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return BTT_MENU_ITEM_COUNT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_ITEM_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellID = @"MenuItemCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }

    cell.textLabel.text = [menuItemNames objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case BTT_MENU_ITEM_CREATE_TASK: {
            [self.navigationController pushViewController:[[BTTCreateTaskController alloc] init] animated:true];
            break;
        }
        case BTT_MENU_ITEM_MYTASK: {
            [self.navigationController pushViewController:[[BTTListTaskController alloc] init] animated:true];
            break;
        }
        case BTT_MENU_ITEM_STATISTICS: {
//            [self.parentNavigationController pushViewController:[[BTTSettingsViewController alloc] init] animated:true];
//            [self.sidePanelController showCenterPanelAnimated:YES];
            break;
        }
        default: {

        }
    }
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
    return NSLocalizedString(@"settings", nil);;
}

@end