//
//  NSManagedObject+GDIHelpers.h
//  GDICoreDataStack
//
//  Created by Grant Davis on 8/31/13.
//  Copyright (c) 2014 Grant Davis Interactive, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 *  This category provides a set of helper methods to create, count, and find
 *  objects in a safe manner.
 */
@interface NSManagedObject (GDIHelpers)


/**
 *  Creates an NSManagedObject in the context. 
 *
 *  This method should be called within a performBlock: call
 *  to the provided context to interact with the newly returned object.
 *  Failure to do so could result in concurrency issues.
 *
 *  @param context the context to create a new subclass of this object in. the context is not saved automatically.
 *
 *  @return an NSManagedObject subclass
 */
+ (id)createObjectInContext:(NSManagedObjectContext *)context;


/**
 *  Creates a fetch request for the current NSManagedObject subclass and performs countForFetchRequest:error on 
 *  the provided managed object context. 
 *
 *  This method should be called within a performBlock: call
 *  to the provided context to interact with the newly returned object.
 *  Failure to do so could result in concurrency issues.
 *
 *  @param predicate the predicate to use when counting objects.
 *  @param context   the context to perform the count request with.
 *
 *  @return the number of objects found. NSNotFound is returned if an error is encountered.
 */
+ (NSUInteger)numberOfEntitiesWithPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;


/**
 *  Creates a new NSFetchRequest instance configured with the receiver's class name as the entity name.
 *
 *  @return a new instance of NSFetchRequest
 */
+ (NSFetchRequest *)fetchRequest;


/**
 *  Safely executes executeFetchRequest:context: within a try/catch statement
 *  and prints any encountered errors to the console.
 *
 *  This method should be called within a performBlock: call
 *  to the provided context to interact with the newly returned object. 
 *  Failure to do so could result in concurrency issues.
 *
 *  @param fetchRequest the fetch request to use when executing the fetch request.
 *  @param context      the context to execute the fetch request in.
 *
 *  @return an array of results, nil if an error was encountered.
 */
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)fetchRequest context:(NSManagedObjectContext *)context;


/**
 *  Creates a fetch request and returns all matches with the given predicate and context.
 *
 *  This method should be called within a performBlock: call
 *  to the provided context to interact with the newly returned object.
 *  Failure to do so could result in concurrency issues.
 *
 *  @param predicate the predicate to use when searching for matching objects.
 *  @param context   the context to find objects in.
 *
 *  @return an array of NSManagedObjects matching the predicate. If no results are found, nil is returned.
 */
+ (NSArray *)findAllWithPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;


/**
 *  Finds the first object in the given context matching the predicate.
 *
 *  @param predicate the predicate to use when searching objects.
 *  @param context   the context to find objects in.
 *
 *  @return the first matching NSManagedObject. If no result is found, nil is returned.
 */
+ (id)findFirstWithPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;


@end
