//
//  GroupsViewController.h
//  test_app3
//
//  Created by Admin on 02.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupsViewController : UIViewController
@property(weak, nonatomic)UITableView* tableView;
@property(weak, nonatomic)UISearchBar* searchBar;

@property(strong, nonatomic)NSMutableArray* rowsToDisplay;


@end
