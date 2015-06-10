//
//  ReadViewController.m
//  Headlines
//
//  Created by Chloe Stars on 6/4/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()

@end

@implementation ReadViewController
@synthesize article;
@synthesize readView;

#pragma mark - Managing the detail item

- (void)configureReader {
    self.navigationItem.title = [article headline];
    /*readability = [[DZReadability alloc] initWithURLToDownload:article.URL options:nil completionHandler:^(DZReadability *sender, NSString *content, NSError *error) {
        if (!error) {
            //NSLog(@"result content:\n%@", content);
            // handle returned content
            UIFont *font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
            NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",
                          font.fontName,
                          (int) font.pointSize,
                          content];
            [readView loadHTMLString:htmlString baseURL:article.URL];
        }
        else {
            // handle error
        }
    }];
    [readability start];*/
    [readView loadRequest:[[NSURLRequest alloc] initWithURL:[article URL]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureReader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
