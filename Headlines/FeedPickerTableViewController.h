//
//  FeedPickerTableViewController.h
//  Headlines
//
//  Created by Chloe Stars on 6/6/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedSource.h"
#import "Feed.h"

@interface FeedPickerTableViewController : UITableViewController
{
    FeedSource *feedSource;
}

@property NSURL *url;
@property NSArray *feeds;

@end
