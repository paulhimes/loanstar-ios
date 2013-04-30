//
//  RequestsViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    UserAccount *currentAccount = [[UserAccount alloc] init];
    currentAccount.userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    [MockServerAdapter getAllItemsWithBorrowsRelatedToUserAccount:currentAccount completion:^(NSArray *items, NSError *error) {
        self.items = items;
    }];
}

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[@"My Requests", @"Requests From Others"];
    }
    
    return _sectionTitles;
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    NSMutableArray *items = [NSMutableArray array];
    
    UserAccount *currentAccount = [[UserAccount alloc] init];
    currentAccount.userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    if (section == 0) {
        // My Requests
        for (Item *item in self.items) {
            for (Borrow *borrow in item.borrows) {
                if (![borrow isActive] && [borrow.borrower.userId isEqualToString:currentAccount.userId]) {
                    [items addObject:item];
                    break;
                }
            }
        }
    } else if (section == 1) {
        // Requests from others
        for (Item *item in self.items) {
            for (Borrow *borrow in item.borrows) {
                if (![borrow isActive] && [borrow.item.owner.userId isEqualToString:currentAccount.userId]) {
                    [items addObject:item];
                    break;
                }
            }
        }
    }
    
    return items;
}

@end
