//
//  ItemListViewController.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Borrow.h"
#import "Format.h"
#import "UserAccount.h"
#import "ServerAdapter.h"
#import "MockServerAdapter.h"

@interface ItemListViewController : UITableViewController

@property (nonatomic, readonly) NSArray *sectionTitles;

- (void)loadItems;
- (NSArray*)itemsInSection:(NSUInteger)section;

@end
