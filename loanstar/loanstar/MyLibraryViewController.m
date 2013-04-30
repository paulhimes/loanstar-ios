//
//  MyLibraryViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "MyLibraryViewController.h"

@interface MyLibraryViewController ()

@property (nonatomic, strong) NSArray *borrowedItems;

@end

@implementation MyLibraryViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems;
{
    UserAccount *currentAccount = [[UserAccount alloc] init];
    currentAccount.userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    [MockServerAdapter getAllItemsOwnedByUserAccount:currentAccount completion:^(NSArray *items, NSError *error) {
        
        self.items = items;
        
        [MockServerAdapter getAllItemsWithBorrowsRelatedToUserAccount:currentAccount completion:^(NSArray *items, NSError *error) {
            
            NSMutableArray *borrowedSubset = [NSMutableArray array];
            for (Item *item in items) {
                // Make sure there is an active borrow attributed to the current user.
                for (Borrow *borrow in item.borrows) {
                    if ([borrow.borrower.userId isEqualToString:currentAccount.userId] && [borrow isActive]) {
                        [borrowedSubset addObject:item];
                        break;
                    }
                }
            }
            
            self.borrowedItems = [borrowedSubset copy];
        }];
        
    }];
}

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[@"At Home", @"Away", @"Borrowed"];
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
    } else {
        items = [self.borrowedItems mutableCopy];
    }
    
    return [items copy];
}

@end
