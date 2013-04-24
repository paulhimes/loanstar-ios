//
//  ItemListViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ItemListViewController.h"
#import "ItemDetailViewController.h"

@interface ItemListViewController ()

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
        
//        // Create a new contact.
//        Contact *contact = [[Contact alloc] init];
//        
//        EditContactViewController *editContactViewController = (EditContactViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
//        editContactViewController.contact = contact;
//        [editContactViewController hideCancelButton];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self itemsInSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];

    // Get the item for this cell.
    Item *item = [self itemsInSection:indexPath.section][indexPath.row];
    cell.textLabel.text = item.title;//[NSString stringWithFormat:@"%@ (%d)", item.title, item.year];
    cell.detailTextLabel.text = item.format.name;
    
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
