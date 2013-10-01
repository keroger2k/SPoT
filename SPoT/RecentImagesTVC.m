//
//  RecentImagesTVCViewController.m
//  SPoT
//
//  Created by Kyle Rogers on 10/1/13.
//  Copyright (c) 2013 Kyle Rogers. All rights reserved.
//

#import "RecentImagesTVC.h"
#import "RecentResult.h"

@interface RecentImagesTVC () <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *recentImagesTableView;
@property (nonatomic, strong) NSArray *recentImages;
@end

@implementation RecentImagesTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recentImages = RecentResult.allRecentImages;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.recentImages = RecentResult.allRecentImages;
    [self.recentImagesTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    RecentResult *result = [self.recentImages objectAtIndex:indexPath.item];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:result.imageURL];
                    [segue.destinationViewController setTitle:result.title];
                }
            }
        }
    }
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.recentImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RecentResult *image = [self.recentImages objectAtIndex:indexPath.item];
    
    cell.textLabel.text = image.title;
    cell.detailTextLabel.text = image.subTitle;
    
    return cell;
}

@end
