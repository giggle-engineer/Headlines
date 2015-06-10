//
//  GlanceController.m
//  Headlines WatchKit Extension
//
//  Created by Chloe Stars on 6/4/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import "GlanceController.h"
#import "HeadlineRowController.h"

@interface GlanceController()

@end


@implementation GlanceController
@synthesize headlineTable;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    ticker = [Ticker new];

    // Configure interface objects here.
    [self refresh];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    // Configure interface objects here.
    [self refresh];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
//    NSLog(@"deactivate");
    [super didDeactivate];
}

#pragma mark - Methods

- (bool)areThereNewHeadlines:(NSArray*)_headlines
{
    //    bool flag = NO;
//    return ![[[_headlines objectAtIndex:0] headline] isEqualToString:[[headlines objectAtIndex:0] headline]];
    return YES;
}

- (void)refresh {
    // Configure interface objects here.
    [ticker refreshHeadlinesWithCompletionBlock:^(NSArray *_headlines) {
        if ([self areThereNewHeadlines:_headlines]) {
            headlines = _headlines;
            // Configure the table object (self.todoItems) and get the row controllers.
            [[self headlineTable] setNumberOfRows:headlines.count withRowType:@"Headlines"];
            NSInteger rowCount = [[self headlineTable] numberOfRows];
            
            // Iterate over the rows and set the label for each one.
            for (NSInteger i = 0; i < rowCount; i++) {
                // Get the to-do item data.
                NSString* itemText = [[headlines objectAtIndex:i] headline];
                
                // Assign the text to the row's label.
                HeadlineRowController* row = [[self headlineTable] rowControllerAtIndex:i];
                [row.headline setText:itemText];
            }
        }
    }];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"tapped a row! %ld", (long)rowIndex);
    //[self updateUserActivity:<#(NSString *)#> userInfo:<#(NSDictionary *)#> webpageURL:<#(NSURL *)#>];
}

@end



