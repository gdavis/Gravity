//
//  GDICoreDataStack.m
//  GDICoreDataKit
//
//  Created by Grant Davis on 9/12/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDICoreDataStack.h"

NSString * const GDICoreDataStackDidRebuildDatabase = @"GDICoreDataStackDidRebuildDatabase";

@implementation GDICoreDataStack {
    NSString *_storeName;
    NSString *_seedPath;
    NSString *_configuration;
}

@synthesize mainContext = _mainContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Public API


- (id)initWithStoreName:(NSString *)storeName seedName:(NSString *)seedName configuration:(NSString *)config
{
    if (self = [super init]) {
        _storeName = storeName;
        _seedPath = seedName != nil ? [[NSBundle mainBundle] pathForResource:seedName ofType:nil] : nil;
        _configuration = config;
        _shouldRebuildDatabaseIfPersistentStoreSetupFails = YES;
    }
    return self;
}


- (id)initWithManagedObjectModel:(NSManagedObjectModel *)model storeName:(NSString *)storeName seedName:(NSString *)seedName configuration:(NSString *)config;
{
    if (self = [super init]) {
        _managedObjectModel = model;
        _storeName = storeName;
        _seedPath = seedName != nil ? [[NSBundle mainBundle] pathForResource:seedName ofType:nil] : nil;
        _configuration = config;
        _shouldRebuildDatabaseIfPersistentStoreSetupFails = YES;
    }
    return self;
}


- (NSPersistentStoreCoordinator *)setupCoreDataStackWithOptions:(NSDictionary *)options completion:(void (^)(BOOL success, NSError *error))completion
{
    NSError *error = nil;
    if (_seedPath) {
        NSString *storePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName] path];
        BOOL success = [self copySeedDatabaseIfNecessaryFromPath:_seedPath
                                                          toPath:storePath
                                                           error:&error];
        if (! success) {
            NSLog(@"Failed to copy seed database at path: %@", _seedPath);
            if (completion) {
                completion(NO, error);
            }
            return nil;
        }
    }
    
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:_configuration
                                                                 URL:self.storeURL
                                                             options:options
                                                               error:&error])
        {
            if (_shouldRebuildDatabaseIfPersistentStoreSetupFails) {
                NSLog(@"error opening persistent store, removing");
                
                error = nil;
                if (![[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&error]) {
                    NSLog(@"error removing persistent store %@, giving up", self.storeURL);
                }
                else {
                    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                         configuration:_configuration
                                                                                                   URL:self.storeURL
                                                                                               options:options
                                                                                                 error:&error];
                    
                    if (store != nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:GDICoreDataStackDidRebuildDatabase object:self];
                    }
                    else {
                        NSLog(@"error opening persistent store, giving up");
                    }
                }
            }
        }
    }
    
    _ready = (_persistentStoreCoordinator != nil);
    
    if (completion) {
        completion(_ready, error);
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Worker Methods


- (BOOL)copySeedDatabaseIfNecessaryFromPath:(NSString *)seedPath toPath:(NSString *)storePath error:(NSError **)error
{
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSError *localError;
        if (![[NSFileManager defaultManager] copyItemAtPath:seedPath toPath:storePath error:&localError]) {
            NSLog(@"Failed to copy seed database from path '%@' to path '%@': %@", seedPath, storePath, [localError localizedDescription]);
            if (error) *error = localError;
            return NO;
        }
        NSLog(@"Successfully copied seed database!");
    }
    return YES;
}


#pragma mark - Context


- (NSManagedObjectContext *)createPrivateContext
{
    return [self createContextWithMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy
                              concurrencyType:NSPrivateQueueConcurrencyType];
}


- (NSManagedObjectContext *)createPrivateContextWithMergePolicy:(id)mergePolicy
{
    return [self createContextWithMergePolicy:mergePolicy
                              concurrencyType:NSPrivateQueueConcurrencyType];
}


- (NSManagedObjectContext *)createContextWithMergePolicy:(id)mergePolicy
                                         concurrencyType:(NSManagedObjectContextConcurrencyType)type
{
    NSManagedObjectContext *context;
    if (self.persistentStoreCoordinator != nil) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
        context.persistentStoreCoordinator = self.persistentStoreCoordinator;
        context.mergePolicy = mergePolicy;
        context.undoManager = nil;
    }
    return context;
}


#pragma mark - Accessors


- (NSURL *)storeURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName];
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}


- (NSManagedObjectContext *)mainContext
{
    NSAssert([NSThread isMainThread], @"This context must be accessed on the main thread!");
    if (_mainContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _mainContext = [self createContextWithMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy
                                              concurrencyType:NSMainQueueConcurrencyType];
        }
    }
    return _mainContext;
}


/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return (directories.count > 0) ? [directories objectAtIndex:0] : nil;
}


@end
