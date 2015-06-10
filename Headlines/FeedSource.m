//
//  FeedSource.m
//  Headlines
//
//  Created by Chloe Stars on 6/5/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "FeedSource.h"
#import "_Feed.h"

@implementation FeedSource

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedFeedSource
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "me.chloestars.Headlines" in the application's documents directory.
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.me.chloestars.Headlines"];
    //return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Headlines" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Headlines.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
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
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
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
            // WARNING: abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendlyName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    //aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - Methods

+ (void)findFeedsForURL:(NSURL *)url handler:(feedsHandler)handler
{
    NSMutableArray *feeds = [NSMutableArray new];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        HTMLDocument *document = [[HTMLDocument alloc] initWithData:responseObject contentTypeHeader:nil];
        HTMLElement *head = [document firstNodeMatchingSelector:@"head"];
        NSArray *links = [head nodesMatchingSelector:@"link"];
        
        // create a group to monitor when all the blocks are queued up and finish
        dispatch_group_t group = dispatch_group_create();
        
        for (HTMLElement *element in links)
        {
            if([[[element attributes] objectForKey:@"rel"] isEqualToString:@"alternate"])
            {
                NSString *elementURL = [[element attributes] objectForKey:@"href"];
                // pair a dispatch_group_enter for each dispatch_group_leave
                dispatch_group_enter(group);
                [self isValidURL:[NSURL URLWithString:elementURL] handler:^(bool isValid) {
                    _Feed *feed = [_Feed new];
                    [feed setUrl:elementURL];
                    NSString *friendlyName = [[element attributes] objectForKey:@"title"];
                    if (friendlyName!=nil) {
                        [feed setFriendlyName:friendlyName];
                    }
                    else
                    {
                        [feed setFriendlyName:[[NSURL URLWithString:elementURL] host]];
                    }
                    [feeds addObject:feed];
                    dispatch_group_leave(group);
                }];
            }
        }
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // we could go ahead and sort the results here alphabetically in case they didn't return that way but it doesn't really matter
            handler(feeds);
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        handler(feeds);
    }];
    
    [op start];
}

- (void)getFriendlyNameForURL:(NSURL*)url handler:(nameHandler)handler
{
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
    
    id dynamicDelegate;
    dynamicDelegate = [[NSObject alloc] init];
    [dynamicDelegate respondsToSelector:@selector(feedParser:didParseFeedInfo:) withKey:nil usingBlock:^(id receiver, MWFeedParser* parser, MWFeedInfo* info) {
//        NSLog(@"title: %@", info.title);
        handler(info.title);
    }];
    
    feedParser.delegate = dynamicDelegate;
    feedParser.feedParseType = ParseTypeInfoOnly;
    [feedParser parse];
}

+ (void)isValidURL:(NSURL*)url handler:(validationHandler)handler
{
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:url];
    
    id dynamicDelegate;
    dynamicDelegate = [[NSObject alloc] init];
    [dynamicDelegate respondsToSelector:@selector(feedParser:didFailWithError:) withKey:nil usingBlock:^(id receiver, id response) {
        handler(NO);
    }];
    [dynamicDelegate respondsToSelector:@selector(feedParserDidFinish:) withKey:nil usingBlock:^(id receiver, id respond) {
        handler(YES);
    }];
    
    feedParser.delegate = dynamicDelegate;
    feedParser.feedParseType = ParseTypeInfoOnly;
    [feedParser parse];
}

- (void)addWithFeed:(_Feed *)_feed
{
    Feed *feed = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:[self managedObjectContext]];
    [feed setUrl:[_feed url]];
    [self getFriendlyNameForURL:[NSURL URLWithString:[_feed url]] handler:^(NSString *friendlyName) {
        [feed setFriendlyName:friendlyName];
        [self saveContext];
    }];
}

- (void)addWithURL:(NSURL*)url
{
    Feed *feed = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Feed"
                  inManagedObjectContext:[self managedObjectContext]];
    [feed setUrl:[url absoluteString]];
    [self getFriendlyNameForURL:url handler:^(NSString *friendlyName) {
        [feed setFriendlyName:friendlyName];
        [self saveContext];
    }];
}

@end
