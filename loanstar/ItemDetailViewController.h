//
//  ItemDetailViewController.h
//  loanstar
//
//  Created by Paul Himes on 4/14/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface ItemDetailViewController : UITableViewController

@property (nonatomic, strong) Item* item;

@end
