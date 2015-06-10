//
//  HandoffController.m
//  Headlines
//
//  Created by Chloe Stars on 6/6/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import "HandoffController.h"
#import "Article.h"

@interface HandoffController ()

@end

@implementation HandoffController
@synthesize headline;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    article = (Article*)context;
    [headline setText:article.headline];
//    NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:@"me.chloestars.Headlines.reading"];
//    [activity setTitle:@"Reading"];
//    [activity setUserInfo:@{@"article":article}];
//    [activity setWebpageURL:article.URL];
//    [activity becomeCurrent];
    [self updateUserActivity:@"me.chloestars.Headlines.reading" userInfo:[article dictionaryRepresentation] webpageURL:article.URL];
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



