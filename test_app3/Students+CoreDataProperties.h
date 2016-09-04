//
//  Students+CoreDataProperties.h
//  test_app3
//
//  Created by Admin on 03.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Students.h"

NS_ASSUME_NONNULL_BEGIN

@interface Students (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *studentsNames;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *studentsGroups;

@end

@interface Students (CoreDataGeneratedAccessors)

- (void)addStudentsGroupsObject:(NSManagedObject *)value;
- (void)removeStudentsGroupsObject:(NSManagedObject *)value;
- (void)addStudentsGroups:(NSSet<NSManagedObject *> *)values;
- (void)removeStudentsGroups:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
