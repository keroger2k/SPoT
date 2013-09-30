//
//  FlickrTagTVCViewController.m
//  SPoT
//
//  Created by Kyle Rogers on 9/28/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "FlickrTagTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoTVC.h"

@interface FlickrTagTVC () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *photos; // of NSDictionary
@property (nonatomic, strong) NSMutableArray *allTags; // of NSDictionary

@end

@implementation FlickrTagTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_queue_t downloadQueue = dispatch_queue_create("get flickr data", NULL);
    dispatch_async(downloadQueue, ^{
        self.photos = [FlickrFetcher stanfordPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tags = [self parseTags];
        });
    });
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
}

- (void)setTags:(NSArray *)tags
{
    _tags = tags;
    [self.tableView reloadData];
}

- (NSArray *)parseTags {
    self.allTags = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.photos count]; i++)
    {
        NSArray *photoTags = [self.photos[i][FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (int ii = 0; ii < [photoTags count]; ii++) {
            if(![photoTags[ii] isEqualToString:@"cs193pspot"] &&
               ![photoTags[ii] isEqualToString:@"portrait"] &&
               ![photoTags[ii] isEqualToString:@"landscape"]){
                [self.allTags addObject:photoTags[ii]];
            }
        }
    }
    return [self.allTags valueForKeyPath:@"@distinctUnionOfObjects.self"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photos"]) {
                FlickrPhotoTVC *photoListVC = (FlickrPhotoTVC *)segue.destinationViewController;
                NSString *tag = [self.tags objectAtIndex:indexPath.item];
                photoListVC.photos = [self photosWithTag:tag];
            }
        }
    }
}

- (NSArray *)photosWithTag:(NSString *)tag
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for ( int i = 0; i < [self.photos count]; i++) {
        if([[self.photos[i][FLICKR_TAGS] componentsSeparatedByString:@" "] containsObject:tag]){
            [items addObject:self.photos[i]];
        }
    }
    return items;
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
    return [self.tags[row] description]; // description because could be NSNull
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
    int c = 0;
    
    for ( int i = 0; i < [self.photos count]; i++) {
        if([[self.photos[i][FLICKR_TAGS] componentsSeparatedByString:@" "] containsObject:[self titleForRow:indexPath.row]]){
            c++;
        }
    }
    NSString *subTitle = [NSString stringWithFormat:@"%d Photos", c];
    cell.detailTextLabel.text = subTitle;
    return cell;
}

@end
