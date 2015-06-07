//
//  InterfaceController.m
//  Headlines WatchKit Extension
//
//  Created by Chloe Stars on 6/4/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import "InterfaceController.h"
#import "HeadlineRowController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    ticker = [Ticker new];
    
    // Configure interface objects here.
    [ticker refreshHeadlinesWithCompletionBlock:^(NSArray *headlines) {
        // Configure the table object (self.todoItems) and get the row controllers.
        [[self headlineTable] setNumberOfRows:headlines.count withRowType:@"default"];
        NSInteger rowCount = [[self headlineTable] numberOfRows];
        
        // Iterate over the rows and set the label for each one.
        for (NSInteger i = 0; i < rowCount; i++) {
            // Get the to-do item data.
            NSString* itemText = [[headlines objectAtIndex:i] headline];
            
            // Assign the text to the row's label.
            HeadlineRowController* row = [[self headlineTable] rowControllerAtIndex:i];
            [row.headline setText:itemText];
        }
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



