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
#import "ServerAdapter.h"
#import "ItemEditViewController.h"
#import "Theme.h"

#define HEADER_HORIZONTAL_PADDING 20

@interface ItemDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;

@property (weak, nonatomic) IBOutlet UIButton *returnedButton;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelRequestButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UILabel *noRequestsLabel;

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

    if (![self.item.owner isEqual:[UserAccount currentUserAccount]]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.tableView.backgroundColor = [Theme backgroundColor];
    
    // Style the buttons
    CGFloat cornerRadius = 5;
    self.requestButton.layer.cornerRadius = cornerRadius;
    self.acceptButton.layer.cornerRadius = cornerRadius;
    self.denyButton.layer.cornerRadius = cornerRadius;
    self.cancelRequestButton.layer.cornerRadius = cornerRadius;
    self.returnedButton.layer.cornerRadius = cornerRadius;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.item.title;
    self.itemTitleLabel.text = self.item.title;
    self.itemYearLabel.text = [NSString stringWithFormat:@"%d", self.item.year];
    self.itemFormatLabel.text = self.item.format.name;
    self.ownerNameLabel.text = self.item.owner.displayName;
    if (self.item.picture) {
        self.pictureImageView.image = self.item.picture;
    }
    [self prepareButtonsAndBorrows];
}

- (void)prepareButtonsAndBorrows
{
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
    
    // Determine which borrow button(s) to show...
    // Hide all the buttons first.
    self.returnedButton.hidden = YES;
    self.requestButton.hidden = YES;
    self.cancelRequestButton.hidden = YES;
    self.acceptButton.hidden = YES;
    self.denyButton.hidden = YES;
    self.noRequestsLabel.hidden = YES;
    
    if ([self.item.owner isEqual:[UserAccount currentUserAccount]]) {
        // The user owns this item. The options are blank, accept / deny a request, or mark it as returned.
        self.noRequestsLabel.hidden = NO;
        for (Borrow *borrow in self.item.borrows) {
            self.noRequestsLabel.hidden = YES;
            NSLog(@"%@", borrow);
            if ([borrow isActive]) {
                // There is an active borrow. This is more important than any pending borrow requests.
                self.returnedButton.hidden = NO;
                self.acceptButton.hidden = YES;
                self.denyButton.hidden = YES;
                break;
            } else {
                self.acceptButton.hidden = NO;
                self.denyButton.hidden = NO;
            }
        }
    } else {
        // The user doesn't own this item. The options are to make a request or cancel a request.
        self.requestButton.hidden = NO;
        // Check if the user is borrowing or has requested to borrow this item.
        for (Borrow *borrow in self.item.borrows) {
            if ([borrow.borrower isEqual:[UserAccount currentUserAccount]]) {
                // This user cannot request this item again.
                self.requestButton.hidden = YES;
                // Check if the request has not been accepted.
                if (![borrow isActive]) {
                    self.cancelRequestButton.hidden = NO;
                }
            }
        }
    }

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

# pragma mark - button handlers

- (IBAction)requestItem:(UIButton *)sender
{
    Borrow *borrow = [[Borrow alloc] init];
    borrow.item = self.item;
    borrow.requestDate = [NSDate date];
    borrow.borrower = [UserAccount currentUserAccount];

    borrow = [ServerAdapter createBorrow:borrow];
    [self.item addBorrow:borrow];
    [self refreshAfterBorrowAction];
}

- (IBAction)cancelRequest:(UIButton *)sender
{
    Borrow *borrow;
    for (borrow in self.item.borrows) {
        if ([borrow.borrower isEqual:[UserAccount currentUserAccount]]) {
            break;
        }
    }
    // give borrow an end date so the server deletes it
    borrow.endDate = [NSDate date];
    [ServerAdapter editBorrow:borrow];
    [self.item removeBorrow:borrow];
    [self refreshAfterBorrowAction];
}

- (IBAction)acceptRequest:(UIButton *)sender
{
    Borrow *borrow = self.item.borrows[0];
    borrow.startDate = [NSDate date];
    [ServerAdapter editBorrow:borrow];
    [self refreshAfterBorrowAction];
}

- (IBAction)returnItemOrDenyRequest:(UIButton *)sender
{
    Borrow *borrow = self.item.borrows[0];
    // give borrow an end date so the server deletes it
    borrow.endDate = [NSDate date];
    [ServerAdapter editBorrow:borrow];
    [self.item removeBorrow:borrow];
    [self refreshAfterBorrowAction];
}

- (void)refreshAfterBorrowAction
{
    [self.tableView reloadData];
    [self prepareButtonsAndBorrows];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.opaque = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Requests";
    titleLabel.font = [Theme titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [Theme navigationTitleColor];
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(0, 0, titleLabel.frame.size.width + HEADER_HORIZONTAL_PADDING, titleLabel.frame.size.height);
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    headerView.backgroundColor = [Theme tableHeaderColor];
    [headerView addSubview:titleLabel];

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.item.borrows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell" forIndexPath:indexPath];
    
    cell.textLabel.font = [Theme titleFont];
    cell.textLabel.textColor = [Theme titleColor];
    cell.detailTextLabel.font = [Theme subtitleFont];
    cell.detailTextLabel.textColor = [Theme subtitleColor];
    
    Borrow *borrow = self.item.borrows[indexPath.row];
    cell.textLabel.text = borrow.borrower.displayName;
    cell.detailTextLabel.text = borrow.status.name;
    
    return cell;
}

@end
