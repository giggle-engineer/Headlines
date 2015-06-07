//
//  Ticker.m
//  Headlines
//
//  Created by Chloe Stars on 6/5/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import "Ticker.h"

@implementation Ticker

- (void)getHeadlineForFeed:(Feed *)feed handler:(headlineHandler)handler
{
    NSLog(@"loading feed");
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:[NSURL URLWithString:[feed url]]];
    
    id dynamicDelegate;
    dynamicDelegate = [[NSObject alloc] init];
    [dynamicDelegate respondsToSelector:@selector(feedParser:didParseFeedItem:) withKey:nil usingBlock:^(id receiver, MWFeedParser* parser, MWFeedItem* item) {
        Article *article = [Article new];
        [article setHeadline:item.title];
        [article setURL:[NSURL URLWithString:item.link]];
//        NSLog(@"title: %@", item.title);
        handler(article);
        [feedParser stopParsing];
    }];
    
    [dynamicDelegate respondsToSelector:@selector(feedParser:didFailWithError:) withKey:nil usingBlock:^(id receiver, id response)
     {
         handler(nil);
     }];
    
    feedParser.delegate = dynamicDelegate;
    feedParser.feedParseType = ParseTypeItemsOnly;
    [feedParser parse];
}

- (void)refreshHeadlinesWithCompletionBlock:(tickerCompletionBlock)handler
{
    NSMutableArray *headlines = [NSMutableArray new];
    
    FeedSource *feedSource = [FeedSource sharedFeedSource];
    NSArray *feeds = [[feedSource fetchedResultsController] fetchedObjects];
    
    // create a group
    dispatch_group_t group = dispatch_group_create();
    
    for (Feed *feed in feeds)
    {
        dispatch_group_enter(group);     // pair 1 enter
        [self getHeadlineForFeed:feed handler:^(Article *headline) {
            if(headline)
            {
                [headlines addObject:headline];
                NSLog(@"added headline");
            }
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        handler(headlines);
    });
}

@end
