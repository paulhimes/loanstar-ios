//
//  GlobalLibraryViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "GlobalLibraryViewController.h"

@interface GlobalLibraryViewController ()

@end

@implementation GlobalLibraryViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    UserAccount *currentAccount = [[UserAccount alloc] init];
    currentAccount.userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    [MockServerAdapter getAllItemsNotOwnedOrBorrowedByUserAccount:currentAccount completion:^(NSArray *items, NSError *error) {
        self.items = items;
    }];
}

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[@"Available", @"On Loan"];
    }
    
    return _sectionTitles;
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    NSMutableArray *items = [NSMutableArray array];
    
    if (section == 0) {
        // Items with no active borrows.
        for (Item *item in self.items) {
            BOOL hasActiveBorrow = NO;
            for (Borrow *borrow in item.borrows) {
                if ([borrow isActive]) {
                    hasActiveBorrow = YES;
                    break;
                }
            }
            if (!hasActiveBorrow) {
                [items addObject:item];
            }
        }
    } else if (section == 1) {
        // Items with active borrows.
        for (Item *item in self.items) {
            for (Borrow *borrow in item.borrows) {
                if ([borrow isActive]) {
                    [items addObject:item];
                    break;
                }
            }
        }
    }
    
    return [items copy];
}


@end
