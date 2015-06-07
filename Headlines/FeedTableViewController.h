//
//  FeedTableViewController.h
//  Headlines
//
//  Created by Chloe Stars on 6/4/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FeedSource.h"

@interface FeedTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    FeedSource *feedSource;
    NSURL *sourceURL;
}


@end

