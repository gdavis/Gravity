//
//  NSManagedObject+Clone.m
//  Gravity
//
//  Created by Grant Davis on 3/18/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSManagedObject+Clone.h"

@implementation NSManagedObject (Clone)

- (NSManagedObject *)clone
{
    return [NSManagedObject clone:self inContext:self.managedObjectContext];
}


+ (NSManagedObject *)clone:(NSManagedObject *)source inContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [[source entity] name];
    
    //create new object in data store
    NSManagedObject *cloned = [NSEntityDescription
                               insertNewObjectForEntityForName:entityName
                               inManagedObjectContext:context];
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:context] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[source valueForKey:attr] forKey:attr];
    }
    
    // copy relationships
    NSDictionary *relationships = [[NSEntityDescription
                                    entityForName:entityName
                                    inManagedObjectContext:context] relationshipsByName];
    NSArray *relationshipKeys = [relationships allKeys];
    for (NSString *keyName in relationshipKeys ) {
        NSManagedObject *relatedObject = [source valueForKey:keyName];
        [cloned setValue:relatedObject forKey:keyName];
    }
    
    return cloned;
}

@end
