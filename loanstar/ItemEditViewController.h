//
//  ItemEditViewController.h
//  loanstar
//
//  Created by Paul Himes on 4/14/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemEditViewController : UITableViewController

@property (nonatomic, strong) Item *item;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *formatField;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
