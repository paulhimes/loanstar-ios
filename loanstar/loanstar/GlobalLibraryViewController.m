//
//  GlobalLibraryViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "GlobalLibraryViewController.h"

@interface GlobalLibraryViewController ()

@property (nonatomic, strong) NSMutableArray *availableItems;
@property (nonatomic, strong) NSMutableArray *loanedItems;

@end

@implementation GlobalLibraryViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    [self.availableItems removeAllObjects];
    [self.loanedItems removeAllObjects];
    
    NSArray *items = [ServerAdapter getAllItemsNotOwnedOrBorrowedByUserAccount:[UserAccount currentUserAccount]];
    
    for (Item *item in items) {
        BOOL hasActiveBorrow = NO;
        for (Borrow *borrow in item.borrows) {
            if ([borrow isActive]) {
                hasActiveBorrow = YES;
                break;
            }
        }
        if (!hasActiveBorrow) {
            // Available Items
            [self.availableItems addObject:item];
        } else {
            // Loaned Items
            [self.loanedItems addObject:item];
        }
    }
    
    // Sort all the arrays.
    NSComparator comparator = ^NSComparisonResult(id obj1, id obj2) {
        return [((Item*)obj1).title compare:((Item*)obj2).title];
    };
    [self.availableItems sortUsingComparator:comparator];
    [self.loanedItems sortUsingComparator:comparator];
}

- (NSMutableArray *)availableItems
{
    if (!_availableItems) {
        _availableItems = [NSMutableArray array];
    }
    return _availableItems;
}

- (NSMutableArray *)loanedItems
{
    if (!_loanedItems) {
        _loanedItems = [NSMutableArray array];
    }
    return _loanedItems;
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
        items = self.availableItems;
    } else if (section == 1) {
        items = self.loanedItems;
    }
    
    return [items copy];
}


@end
