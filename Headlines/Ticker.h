//
//  Ticker.h
//  Headlines
//
//  Created by Chloe Stars on 6/5/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWFeedParser/MWFeedParser.h>
#import "FeedSource.h"
#import "Article.h"

@interface Ticker : NSObject

typedef void (^headlineHandler)(Article *headline);
typedef void (^tickerCompletionBlock)(NSArray* array);

- (void)refreshHeadlinesWithCompletionBlock:(tickerCompletionBlock)block;
- (void)getHeadlineForFeed:(Feed*)feed handler:(headlineHandler)handler;

@end
