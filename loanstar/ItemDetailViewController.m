//
//  ItemDetailViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/14/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Format.h"
#import "UserAccount.h"
#import "Borrow.h"
#import "Status.h"
#import "ItemEditViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

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
    
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];

    if (![self.item.owner.userId isEqualToString:currentUserId]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.item.title;
    self.itemTitleLabel.text = self.item.title;
    self.itemYearLabel.text = [NSString stringWithFormat:@"%d", self.item.year];
    self.itemFormatLabel.text = self.item.format.name;
    
    // Determine the item status...
    BOOL activeBorrow = NO;
    // Check if any of the borrows are active as of now.
    NSDate *now = [NSDate date];
    for (Borrow *borrow in self.item.borrows) {
        if (borrow.startDate && borrow.startDate.timeIntervalSince1970 < now.timeIntervalSince1970) {
            // Borrow started before now.
            if (!borrow.endDate || borrow.endDate.timeIntervalSince1970 > now.timeIntervalSince1970) {
                // Borrow has not yet ended.
                activeBorrow = YES;
                break;
            }
        }
    }
    self.itemStatusLabel.text = activeBorrow ? @"Loaned Out" : @"Available";
    
    self.ownerNameLabel.text = self.item.owner.displayName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        UINavigationController *navController = segue.destinationViewController;
        ItemEditViewController *editViewController = (ItemEditViewController*)navController.topViewController;
        editViewController.item = self.item;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Requests";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.item.borrows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell" forIndexPath:indexPath];
    
    Borrow *borrow = self.item.borrows[indexPath.row];
    cell.textLabel.text = borrow.borrower.displayName;
    cell.detailTextLabel.text = borrow.status.name;
    
    return cell;
}

@end
