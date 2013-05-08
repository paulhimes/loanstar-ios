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
    
    NSArray *ownedItems = [ServerAdapter getAllItemsOwnedByUserAccount:[UserAccount currentUserAccount]];
    
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
    [self.borrowedItems addObjectsFromArray:[ServerAdapter getAllItemsCurrentlyBorrowedByUserAccount:[UserAccount currentUserAccount]]];
    
    // Sort all the arrays.
    NSComparator comparator = ^NSComparisonResult(id obj1, id obj2) {
        return [((Item*)obj1).title compare:((Item*)obj2).title];
    };
    [self.atHomeItems sortUsingComparator:comparator];
    [self.awayItems sortUsingComparator:comparator];
    [self.borrowedItems sortUsingComparator:comparator];
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
