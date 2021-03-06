//
//  AppDelegate.m
//  test_app3
//
//  Created by Admin on 01.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupsViewController.h"
#import "Names.h"
#import "Students.h"
#import "Groups.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

//Заполнение базы данных
-(void)fillingCoreData{
    int namesArraySize = sizeof(names)/sizeof(names[0]);
        //внешний цикл - заполняет сущность "Groups"
        for (int j = 1; j <= groupsNumber; j++) {
            
            Groups* group = [NSEntityDescription insertNewObjectForEntityForName:@"Groups"
                                                          inManagedObjectContext:self.managedObjectContext];
            group.groupsNames = [[NSString stringWithFormat:@"%d",j] stringByAppendingString:@"-й курс"];
            //массив индексов доступных имен для каждой группы
            NSMutableArray* validNamesNumbers = [[NSMutableArray alloc]init];
            //в следующем цикле заполнияем этот массив числами, соответствующими индексам массива имен из файла Names.h (Казалось бы зачем заполнять массив элементами которые так же являются индексами этого массива. Это сделанно для того, чтоб можно было выбрать случайный элемент из этого массива в цикле заполнения групп студентами (этот цикл идет после нижестоящего) затем из статического массива имен, который находится в файле Names.h, взять в нем элемент под индексом соответствующим элементу выбранному из массива validNamesNumbers, затем удалить его (выбранный случайный элемент из массива validNamesNumbers), такми образом значение в элементе массива validNamesNumbers - служит нам номером для номером имени, которое мы достаем из статического массива в файле Names.h, а индекс - по нему мы делаем слчайный выбор элемента, тот факт что после выбора элемента мы удаляем его  - не дает возможности повторяться именам в группе)
            for (int i = 0; i < namesArraySize; i++) {
                [validNamesNumbers addObject:[NSNumber numberWithInt:i]];
            }
            
            int numOfStudsInGroup = arc4random_uniform(6)+10;  //число студентов в каждой группе (по 10-15 человек)
            //внутренний цикл - заполнения групп студентами
            for (int i = 0; i < numOfStudsInGroup; i++) {
                //выбираем случайный элемент из массива индексов доступных имен для каждой группы(индексы доступных имен - есть элементы этого массива)
                int temp = arc4random_uniform((int)[validNamesNumbers count]);
                //далее сохраняем этот номер в переменную
                int nameNumber = [[validNamesNumbers objectAtIndex:temp] intValue];
                //удаляем элемент с выбранным номером из массива индексов доступных имен для каждой группы, чтобы имена в группе не повтарялись
                [validNamesNumbers removeObjectAtIndex:temp];
                
                //достаем всех студентов добавленных в базу данных, у которых имя такое же какое мы выбрали (переменная nameNumbers - индекс доступного имени из массива имен)
                NSFetchRequest* request = [[NSFetchRequest alloc]init];
                NSEntityDescription*description =
                [NSEntityDescription entityForName:@"Students"
                            inManagedObjectContext:self.managedObjectContext];
                
                NSSortDescriptor* namesSortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"studentsNames" ascending:YES];
                [request setSortDescriptors:@[namesSortDescriptor]];
                
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@" studentsNames == %@", names[nameNumber]];
                [request setPredicate:predicate];
                
                
                [request setEntity:description];
                
                NSError* requestError = nil;
                NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
                if (requestError) {
                    NSLog(@"%@", [requestError localizedDescription]);
                };
                //если студента с таким именем еще нет в базе данных - мы его добавляем в в базу данных к данной группе
                if ([resultArray count] == 0) {
                    Students* student = [NSEntityDescription insertNewObjectForEntityForName:@"Students"
                                                                      inManagedObjectContext:self.managedObjectContext];
                    student.studentsNames = names[nameNumber];
                    
                    [group addStudentsInGroupObject:student];
                    
                    [self.managedObjectContext save:nil];
                }else{//если студент с таким именем уже есть под другой группой, то просто добавляем к имеющемуся студенту еще одну группу
                    [[resultArray objectAtIndex:0] addStudentsGroupsObject:group];
                }
            }
        }
        NSError* error = nil;
        if(![self.managedObjectContext save:&error]){//производим сохранение
            NSLog(@"%@",[error localizedDescription]);
        }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self fillingCoreData];
    }
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    GroupsViewController* controller = [[GroupsViewController alloc]init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
    self.window.rootViewController = self.navigationController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Yangibazar.test_app3" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"test_app3" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test_app3.sqlite"];
    NSError *error = nil;
    //NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        /*NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();*/
        [[NSFileManager defaultManager]removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
