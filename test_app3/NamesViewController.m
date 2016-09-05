//
//  NamesViewController.m
//  test_app3
//
//  Created by Admin on 01.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//
#import "AppDelegate.h"
#import "Groups.h"
#import "RowsClass.h"
#import "Students.h"
#import "NamesViewController.h"
#import "StudentViewController.h"


@interface NamesViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate>


{AppDelegate* appDelegate;}
@end

@implementation NamesViewController


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
    appDelegate = [[UIApplication sharedApplication]delegate];
    self.rowsToDisplay = [[NSMutableArray alloc]init];
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription*description =
    [NSEntityDescription entityForName:@"Students"
                inManagedObjectContext:appDelegate.managedObjectContext];
    NSLog(@"%@", self.group.objectID);

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SUBQUERY(studentsGroups, $sg, $sg == %@).@count >=%d",self.group.objectID, 1];
    
    
    [request setPredicate:predicate];
    [request setEntity:description];
    
    NSSortDescriptor* namesSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"studentsNames" ascending:YES];
    [request setSortDescriptors:@[namesSortDescriptor]];
    
    NSError* requestError = nil;
    NSArray* resultArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    };
    
    
    //NSArray* arrayOfStudents = [self.group.studentsInGroup allObjects];
    
    for (Students* obj in resultArray) {
        RowsClass* rowObj = [[RowsClass alloc]init];
        rowObj.itsRow = obj.studentsNames;
        rowObj.itsID = obj.objectID;
        [self.rowsToDisplay addObject:rowObj];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.group.studentsInGroup  count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[self.rowsToDisplay objectAtIndex:indexPath.row] itsRow];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StudentViewController* namesVC = [[StudentViewController alloc]init];
    
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription*description =
    [NSEntityDescription entityForName:@"Students"
                inManagedObjectContext:appDelegate.managedObjectContext];
   
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF == %@",[[self.rowsToDisplay objectAtIndex:indexPath.row] itsID]];
    
    [request setPredicate:predicate];
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [appDelegate.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    };
    
    namesVC.student = [resultArray objectAtIndex:0];
    
    [self.navigationController pushViewController:namesVC animated:YES];
   
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

@end
