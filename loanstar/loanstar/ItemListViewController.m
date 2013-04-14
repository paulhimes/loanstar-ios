//
//  ItemListViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ItemListViewController.h"
#import "Item.h"
#import "ItemDetailViewController.h"
#import "Format.h"
#import "UserAccount.h"

@interface ItemListViewController ()

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        Item *item;
        switch (indexPath.section) {
            case 0:
                item = [self topSectionItems][indexPath.row];
                break;
            case 1:
                item = [self bottomSectionItems][indexPath.row];
                break;
            default:
                break;
        }
        itemDetailViewController.item = item;
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.topSectionTitle;
        case 1:
            return self.bottomSectionTitle;
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [[self topSectionItems] count];
            break;
        case 1:
            return [[self bottomSectionItems] count];
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
//    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    
    // Get the item for this cell.
    Item *item;
    switch (indexPath.section) {
        case 0:
            item = [self topSectionItems][indexPath.row];
            break;
        case 1:
            item = [self bottomSectionItems][indexPath.row];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", item.title, item.year];
    cell.detailTextLabel.text = item.format.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Helper methods

- (NSArray*)topSectionItems
{
    NSArray *items = @[[Item itemWithTitle:@"Serenity" year:2005 format:[Format vhs]]];
    UserAccount *chad = [[UserAccount alloc] init];
    chad.displayName = @"Chadm";
    ((Item*)items[0]).owner = chad;
    
    return items;
}

- (NSArray*)bottomSectionItems
{
    NSArray *items = @[[Item itemWithTitle:@"Star Wars" year:1977 format:[Format bluray]]];
    return items;
}

@end
