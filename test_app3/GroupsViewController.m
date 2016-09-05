//
//  GroupsViewController.m
//  test_app3
//
//  Created by Admin on 01.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//
#import "AppDelegate.h"
#import "GroupsViewController.h"
#import "NamesViewController.h"
#import "Groups.h"
#import "Students.h"

static int groupsNumber = 3;

@interface GroupsViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

{

AppDelegate* appDelegate;

}
@end

@implementation GroupsViewController

-(void)loadView{
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 60, 420, 40)];
    searchBar.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    
    searchBar.delegate = self;
    self.searchBar = searchBar;
    [self.view addSubview:searchBar];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rowsToDisplay = [[NSMutableArray alloc]init];
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    //self.displayItems = [[NSMutableArray alloc]initWithArray:];
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription*description =
    [NSEntityDescription entityForName:@"Groups"
                inManagedObjectContext:appDelegate.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    };
    
    for(Groups* obj in resultArray){
        [self.rowsToDisplay addObject:obj.groupsNames];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return groupsNumber;//всегда равно 3
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    //в случае если число групп задумается увеличить
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.rowsToDisplay objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NamesViewController* namesVC = [[NamesViewController alloc]init];
    
    namesVC.group = [self getGroupForRow:indexPath.row];
    
    [self.navigationController pushViewController:namesVC animated:YES];
    
}

-(Groups*)getGroupForRow:(NSInteger)row{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription*description =
    [NSEntityDescription entityForName:@"Groups"
                inManagedObjectContext:appDelegate.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    };
    
    Groups* group= [resultArray objectAtIndex:row];
    
    return group;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


@end
