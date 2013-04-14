//
//  ItemEditViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/14/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ItemEditViewController.h"
#import "Format.h"

@interface ItemEditViewController ()

@end

@implementation ItemEditViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.item.title;
    self.titleField.text = self.item.title;
    self.yearField.text = [NSString stringWithFormat:@"%d", self.item.year];
    self.formatField.text = self.item.format.name;
}

- (IBAction)saveButtonPressed:(id)sender {
    [self dismiss];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismiss];
}

- (void)dismiss
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
