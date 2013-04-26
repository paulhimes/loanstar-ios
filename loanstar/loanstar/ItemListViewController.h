//
//  ItemListViewController.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Format.h"
#import "UserAccount.h"
#import "ServerAdapter.h"

@interface ItemListViewController : UITableViewController

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, readonly) NSArray *sectionTitles;

- (void)loadItems;
- (NSArray*)itemsInSection:(NSUInteger)section;

@end
