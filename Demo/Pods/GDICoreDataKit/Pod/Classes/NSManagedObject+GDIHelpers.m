//
//  NSManagedObject+GDIHelpers.m
//  GDICoreDataStack
//
//  Created by Grant Davis on 8/31/13.
//  Copyright (c) 2014 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSManagedObject+GDIHelpers.h"


@implementation NSManagedObject (GDIHelpers)


+ (id)createObjectInContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(context);
    __block NSManagedObject *obj;
    [context performBlockAndWait:^{
        obj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                            inManagedObjectContext:context];
    }];
    return obj;
}


+ (NSFetchRequest *)fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
}


+ (NSUInteger)numberOfEntitiesWithPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    NSParameterAssert(predicate);
    NSParameterAssert(context);
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    fetchRequest.predicate = predicate;
    __block NSUInteger count = 0;
    [context performBlockAndWait:^{
        count = [context countForFetchRequest:fetchRequest error:nil];
    }];
    return count;
}


+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest context:(NSManagedObjectContext *)context
{
    NSParameterAssert(fetchRequest);
    NSParameterAssert(context);
    __block NSArray *results;
    [context performBlockAndWait:^{
        NSError *fetchError;
        @try {
            results = [context executeFetchRequest:fetchRequest error:&fetchError];
        }
        @catch (NSException *exception) {
            results = nil;
        }
        @finally {}
        
        if (results == nil) {
            NSAssert(fetchError == nil, @"Encountered fetch error: %@", fetchError);
        }
    }];
    return results;
}


+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    NSParameterAssert(predicate);
    NSParameterAssert(context);
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:predicate];
    [request setFetchBatchSize:50];
    return [self executeFetchRequest:request context:context];
}


+ (id)findFirstWithPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    NSParameterAssert(predicate);
    NSParameterAssert(context);
    NSFetchRequest *request = [self fetchRequest];
    [request setFetchLimit:1];
    [request setFetchBatchSize:1];
    [request setPredicate:predicate];
    NSArray *results = [self executeFetchRequest:request context:context];
    if (results.count > 0) {
        return [results lastObject];
    }
    return nil;
}

@end
