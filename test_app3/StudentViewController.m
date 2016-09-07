//
//  StudentViewController.m
//  test_app3
//
//  Created by Admin on 02.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//
#import "Students.h"
#import "AppDelegate.h"
#import "StudentViewController.h"

@interface StudentViewController ()
{AppDelegate* appDelegate;}
@end

@implementation StudentViewController

-(void)loadView{
    
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
   
    
    float quarter = (self.view.bounds.size.width > self.view.bounds.size.height) ? self.view.bounds.size.height/2 : self.view.bounds.size.width/2;
    
    UIImageView* photo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 74, quarter-15, quarter-15)];//сторона фотографии - четверть меньшей части
    
    NSURL *url = [NSURL URLWithString:@"http://dializa.md/wp-content/uploads/2015/06/no-avatar-ff.png"];//url пришлось использовать потому, что на git не закидывался png файл
    NSData *data = [NSData dataWithContentsOfURL:url];
    photo.image = [UIImage  imageWithData:data];
    
    [self.view addSubview:photo];
    
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(10, quarter+5+74, quarter*2-20, 35)];
    
    name.text = [self.student studentsNames];
    [self.view addSubview:name];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = [[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
