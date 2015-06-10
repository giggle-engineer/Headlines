//
//  ReadViewController.h
//  Headlines
//
//  Created by Chloe Stars on 6/4/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZReadability/DZReadability.h>
#import "Article.h"

@interface ReadViewController : UIViewController
{
    DZReadability *readability;
}

@property Article *article;
@property IBOutlet UIWebView *readView;

@end

