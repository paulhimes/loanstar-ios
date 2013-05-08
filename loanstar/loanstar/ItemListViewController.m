//
//  ItemListViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ItemListViewController.h"
#import "ItemDetailViewController.h"
#import "LoadingCell.h"
#import "ItemEditViewController.h"
#import "Theme.h"

@interface ItemListViewController ()

@property (nonatomic) BOOL dataLoaded;

@end

@implementation ItemListViewController
@synthesize sectionTitles = _sectionTitles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [Theme backgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.dataLoaded = NO;
    [super viewWillAppear:animated];
    [self loadItems];
    // Items have been loaded. Dismiss the waiting / loading view and refresh the table.
    self.dataLoaded = YES;
    [self.tableView reloadData];
    
    [self.navigationController.navigationBar setNeedsLayout];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Detail"]) {
        ItemDetailViewController *itemDetailViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        itemDetailViewController.item = [self itemsInSection:indexPath.section][indexPath.row];
    } else if ([segue.identifier isEqualToString:@"Add"]) {
        UINavigationController *navController = segue.destinationViewController;
        ItemEditViewController *editViewController = (ItemEditViewController*)navController.topViewController;
        Item *item = [[Item alloc] init];
        item.owner = [UserAccount currentUserAccount];
        editViewController.item = item;
    }
}

- (void)loadItems
{
    // Override this method to actually load something.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSUInteger numberOfSections = self.dataLoaded ? [self.sectionTitles count] : 1;
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.dataLoaded ? self.sectionTitles[section] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataLoaded ? [[self itemsInSection:section] count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (self.dataLoaded) {
        // Item Cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.textLabel.font = [Theme bodyTextFont];
        cell.detailTextLabel.font = [Theme bodyTextSmallFont];
        
        // Get the item for this cell.
        Item *item = [self itemsInSection:indexPath.section][indexPath.row];
        
        if (item.picture) {
            cell.imageView.image = item.picture;
        } else {
            // Show the placeholder image.
            cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
            
            if ([item.pictureUrl length] > 0) {
                // Load the picture from the server.
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    UIImage *picture = [ServerAdapter loadImageFromURL:item.pictureUrl];
                    // If the picture successfully loaded.
                    if (picture) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            // Set the picture on the main queue.
                            item.picture = picture;
                            // If the cell for this item is still visible on screen.
                            if ([[tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                                // Set the cell image to the item's picture.
                                cell.imageView.image = item.picture;
                            }
                        });
                    }
                });                
            }
        }
        
        cell.textLabel.text = item.title;//[NSString stringWithFormat:@"%@ (%d)", item.title, item.year];
        cell.detailTextLabel.text = item.format.name;
    } else {
        // Loading Cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
        LoadingCell *loadingCell = (LoadingCell*)cell;
        [loadingCell.activityIndicator startAnimating];
    }
    
    return cell;
}

#pragma mark - Model Methods

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[];
    }
    
    return _sectionTitles;
}

- (NSArray*)itemsInSection:(NSUInteger)section
{
    return @[];
}

@end
