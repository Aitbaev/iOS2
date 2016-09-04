//
//  Groups+CoreDataProperties.h
//  test_app3
//
//  Created by Admin on 03.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Groups.h"

NS_ASSUME_NONNULL_BEGIN

@interface Groups (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *groupsNames;
@property (nullable, nonatomic, retain) NSSet<Students *> *studentsInGroup;

@end

@interface Groups (CoreDataGeneratedAccessors)

- (void)addStudentsInGroupObject:(Students *)value;
- (void)removeStudentsInGroupObject:(Students *)value;
- (void)addStudentsInGroup:(NSSet<Students *> *)values;
- (void)removeStudentsInGroup:(NSSet<Students *> *)values;

@end

NS_ASSUME_NONNULL_END
