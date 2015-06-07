//
//  FeedPickerTableViewController.m
//  Headlines
//
//  Created by Chloe Stars on 6/6/15.
//  Copyright (c) 2015 Chloe Stars. All rights reserved.
//

#import "FeedPickerTableViewController.h"
#import "_Feed.h"

@interface FeedPickerTableViewController ()

@end

@implementation FeedPickerTableViewController
@synthesize feeds;
@synthesize url;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    feedSource = [FeedSource sharedFeedSource];
    [FeedSource findFeedsForURL:url handler:^(NSArray *foundFeeds) {
        dispatch_async(dispatch_get_main_queue(), ^{
            feeds = foundFeeds;
            // there's only 1 feed! just add it, no need to show a selection
            if ([feeds count]<2) {
                [feedSource addWithFeed:[feeds firstObject]];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            // no feed! detected for this really should be moved into the feed table view controller
            if ([feeds count]==0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            [[self tableView] reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)subscribe:(id)sender
{
    [feedSource addWithFeed:[feeds objectAtIndex:[[[self tableView] indexPathForSelectedRow] row]]];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"picker" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    _Feed *feed = [feeds objectAtIndex:[indexPath row]];
    cell.textLabel.text = [feed friendlyName];
}

@end
