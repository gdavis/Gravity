//
//  NSManagedObject+Clone.h
//  Gravity
//
//  Adopted from: http://stackoverflow.com/questions/2730832/how-can-i-duplicate-or-copy-a-core-data-managed-object
//
//  Created by Grant Davis on 3/18/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Clone)

- (NSManagedObject *)clone;
+ (NSManagedObject *)clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context;

@end
