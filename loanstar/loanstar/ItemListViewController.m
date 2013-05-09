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

#define HEADER_HORIZONTAL_PADDING 20

@interface ItemListViewController ()

@property (nonatomic) BOOL dataLoaded;

@end

@implementation ItemListViewController

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
    [self reloadListItems];
    [self.refreshControl addTarget:self
                            action:@selector(reloadListItems)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.backgroundColor = [Theme backgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setNeedsLayout];
}

- (void)reloadListItems
{
    [self.refreshControl beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self loadItems];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataLoaded = YES;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
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
    NSUInteger numberOfSections = self.dataLoaded ? [self.sectionTitles count] : 0;
    return numberOfSections;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    if (self.dataLoaded && [self.sectionTitles count] > section) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.opaque = NO;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = self.sectionTitles[section];
        titleLabel.font = [Theme titleFont];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [Theme navigationTitleColor];
        [titleLabel sizeToFit];
        titleLabel.frame = CGRectMake(0, 0, titleLabel.frame.size.width + HEADER_HORIZONTAL_PADDING, titleLabel.frame.size.height);
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleLabel.frame.size.width, titleLabel.frame.size.height)];
        headerView.backgroundColor = [Theme tableHeaderColor];
        [headerView addSubview:titleLabel];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self tableView:tableView viewForHeaderInSection:section].frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataLoaded ? [[self itemsInSection:section] count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    if (self.dataLoaded && [[self itemsInSection:indexPath.section] count] > indexPath.row) {
        // Configure the cell...
        cell.textLabel.font = [Theme titleFont];
        cell.textLabel.textColor = [Theme titleColor];
        cell.detailTextLabel.font = [Theme subtitleFont];
        cell.detailTextLabel.textColor = [Theme subtitleColor];
        
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
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

#pragma mark - Model Methods

- (NSArray *)sectionTitles
{
    return @[];
}

- (NSArray*)itemsInSection:(NSUInteger)section
{
    return @[];
}

@end
