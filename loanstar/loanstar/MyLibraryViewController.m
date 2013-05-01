//
//  MyLibraryViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "MyLibraryViewController.h"

@interface MyLibraryViewController ()

@property (nonatomic, strong) NSMutableArray *atHomeItems;
@property (nonatomic, strong) NSMutableArray *awayItems;
@property (nonatomic, strong) NSMutableArray *borrowedItems;

@end

@implementation MyLibraryViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    [self.atHomeItems removeAllObjects];
    [self.awayItems removeAllObjects];
    
    NSArray *ownedItems = [ServerAdapter getAllItemsOwnedByUserAccount:[UserAccount currentUserAccount] error:NULL];
    
    for (Item *item in ownedItems) {
        BOOL hasActiveBorrow = NO;
        for (Borrow *borrow in item.borrows) {
            if ([borrow isActive]) {
                hasActiveBorrow = YES;
                break;
            }
        }
        
        if (!hasActiveBorrow) {
            // At Home Items - no active borrows
            [self.atHomeItems addObject:item];
        } else {
            // Away Items - active borrows
            [self.awayItems addObject:item];
        }
    }
    
    [self.borrowedItems removeAllObjects];
    
    NSArray *itemsWithRelatedBorrows = [ServerAdapter getAllItemsWithBorrowsRelatedToUserAccount:[UserAccount currentUserAccount] error:NULL];
    
    for (Item *item in itemsWithRelatedBorrows) {
        // Make sure there is an active borrow attributed to the current user.
        for (Borrow *borrow in item.borrows) {
            if ([borrow.borrower isEqual:[UserAccount currentUserAccount]] && [borrow isActive]) {
                [self.borrowedItems addObject:item];
                break;
            }
        }
    }
}

- (NSMutableArray *)atHomeItems
{
    if (!_atHomeItems) {
        _atHomeItems = [NSMutableArray array];
    }
    return _atHomeItems;
}

- (NSMutableArray *)awayItems
{
    if (!_awayItems) {
        _awayItems = [NSMutableArray array];
    }
    return _awayItems;
}

- (NSMutableArray *)borrowedItems
{
    if (!_borrowedItems) {
        _borrowedItems = [NSMutableArray array];
    }
    return _borrowedItems;
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
        items = self.atHomeItems;
    } else if (section == 1) {
        items = self.awayItems;
    } else {
        items = self.borrowedItems;
    }
    
    return [items copy];
}

@end
