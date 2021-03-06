//
//  Feed.h
//  Headlines
//
//  Created by Chloe Stars on 6/5/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString *friendlyName; // This property is retrieved from the title tag of the feed
@property (nonatomic, retain) NSString *url; // The feed URL

@end
