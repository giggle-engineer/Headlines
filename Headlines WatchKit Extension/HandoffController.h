//
//  HandoffController.h
//  Headlines
//
//  Created by Chloe Stars on 6/6/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "Article.h"

@interface HandoffController : WKInterfaceController
{
    Article *article;
}

@property IBOutlet WKInterfaceLabel *headline;
@property IBOutlet WKInterfaceLabel *lead;

@end
