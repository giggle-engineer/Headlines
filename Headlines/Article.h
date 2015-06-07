//
//  Article.h
//  Headlines
//
//  Created by Chloe Stars on 6/5/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AutoCoding/AutoCoding.h>

@interface Article : NSObject

@property NSURL *URL; // The URL of the article
@property NSString *headline; // The title of the article
@property NSString *lead; // This is the first two or three lines of the first paragraph from the article.

@end