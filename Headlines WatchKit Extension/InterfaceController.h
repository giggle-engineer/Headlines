//
//  InterfaceController.h
//  Headlines WatchKit Extension
//
//  Created by Chloe Stars on 6/4/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Ticker.h"

@interface InterfaceController : WKInterfaceController
{
    Ticker *ticker;
    NSArray *headlines;
}

@property IBOutlet WKInterfaceTable *headlineTable;

@end
