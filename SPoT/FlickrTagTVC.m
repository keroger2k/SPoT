//
//  FlickrTagTVCViewController.m
//  SPoT
//
//  Created by Kyle Rogers on 9/28/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "FlickrTagTVC.h"
#import "FlickrFetcher.h"

@interface FlickrTagTVC () <UITableViewDataSource>

@end

@implementation FlickrTagTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tags = [FlickrFetcher stanfordPhotos];
}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tags count];
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the title out of it

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.tags[row][FLICKR_TAGS] description]; // description because could be NSNull
}

// a helper method that looks in the Model for the photo dictionary at the given row
//  and gets the owner of the photo out of it

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [self.tags[row][FLICKR_PHOTO_OWNER] description]; // description because could be NSNull
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
