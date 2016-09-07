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
#import "StudentViewController.h"
#import "Groups.h"
#import "Students.h"
#import "Names.h"



@interface GroupsViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>

{

AppDelegate* appDelegate;

}
@end

@implementation GroupsViewController

-(void)loadView{
    
    [super loadView];
    
    CGRect frame = self.view.bounds;
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 65, 415, 40)];
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
        [self.rowsToDisplay addObject:obj];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rowsToDisplay count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    //в случае если число групп задумается увеличить
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if([[self.rowsToDisplay objectAtIndex:indexPath.row] isKindOfClass:[Groups class]])
        cell.textLabel.text = [[self.rowsToDisplay objectAtIndex:indexPath.row] groupsNames];//itsRow];
    else
        cell.textLabel.text = [[self.rowsToDisplay objectAtIndex:indexPath.row] studentsNames];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([[self.rowsToDisplay objectAtIndex:indexPath.row] isKindOfClass:[Groups class]]){
        NamesViewController* studentsVC = [[NamesViewController alloc]init];
        
        studentsVC.group = [self.rowsToDisplay objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:studentsVC animated:YES];
    }else{
        StudentViewController* namesVC = [[StudentViewController alloc]init];
        namesVC.student = [self.rowsToDisplay objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:namesVC animated:YES];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length] == 0) {
        [self.rowsToDisplay removeAllObjects];
        /*
        NSFetchRequest* request = [[NSFetchRequest alloc]init];
        NSEntityDescription*description =
        [NSEntityDescription entityForName:@"Students"
                    inManagedObjectContext:appDelegate.managedObjectContext];
        
        NSSortDescriptor* namesSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"studentsNames" ascending:YES];
        [request setSortDescriptors:@[namesSortDescriptor]];

        [request setEntity:description];
        
        NSError* requestError = nil;
        NSArray* resultArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
        if (requestError) {
            NSLog(@"%@", [requestError localizedDescription]);
        };
        
        for(Students* obj in resultArray){
            [self.rowsToDisplay addObject:obj];
        }
        */
        
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
            [self.rowsToDisplay addObject:obj];
        }

        
    }else{
        [self.rowsToDisplay removeAllObjects];
        
        NSFetchRequest* request = [[NSFetchRequest alloc]init];
        NSEntityDescription*description =
        [NSEntityDescription entityForName:@"Students"
                    inManagedObjectContext:appDelegate.managedObjectContext];
        
        NSSortDescriptor* namesSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"studentsNames" ascending:YES];
        [request setSortDescriptors:@[namesSortDescriptor]];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@" studentsNames CONTAINS[c] %@", searchText];
        [request setPredicate:predicate];
        
        
        [request setEntity:description];
        
        NSError* requestError = nil;
        NSArray* resultArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
        if (requestError) {
            NSLog(@"%@", [requestError localizedDescription]);
        };
        
        for(Students* obj in resultArray){
            [self.rowsToDisplay addObject:obj];
        }
    }
    [self.tableView reloadData];
}



- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}


@end
