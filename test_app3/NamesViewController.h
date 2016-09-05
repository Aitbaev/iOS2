//
//  NamesViewController.h
//  test_app3
//
//  Created by Admin on 01.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Groups;
@class RowsClass;
@interface NamesViewController : UIViewController

@property(weak, nonatomic)UITableView* tableView;
@property(strong, nonatomic)Groups* group;
@property(strong, nonatomic)NSMutableArray* rowsToDisplay;;
@property(weak, nonatomic)UISearchBar* searchBar;


@end
