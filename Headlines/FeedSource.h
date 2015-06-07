//
//  FeedSource.h
//  Headlines
//
//  Created by Chloe Stars on 6/5/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MWFeedParser/MWFeedParser.h>
#import <REKit/REKit.h>
#import <HTMLReader/HTMLReader.h>
#import "Feed.h"
#import "_Feed.h"

@interface FeedSource : NSObject <MWFeedParserDelegate>

typedef void (^validationHandler)(bool isValid);
typedef void (^nameHandler)(NSString *friendlyName);
typedef void (^feedsHandler)(NSArray *feeds);

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (instancetype)sharedFeedSource;

+ (void)findFeedsForURL:(NSURL*)url handler:(feedsHandler)block;
- (void)addWithFeed:(_Feed*)feed;
- (void)addWithURL:(NSURL*)url;
+ (void)isValidURL:(NSURL*)url handler:(validationHandler)block;

@end
