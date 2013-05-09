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
    NSMutableArray *titles = [NSMutableArray array];
    
    if ([self.atHomeItems count] > 0) {
        [titles addObject:@"At Home"];
    }
    if ([self.awayItems count] > 0) {
        [titles addObject:@"Away"];
    }
    if ([self.borrowedItems count] > 0) {
        [titles addObject:@"Borrowed"];
    }
    
    return [titles copy];
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    NSArray *items = @[];
    
    NSArray *sectionTitles = [self sectionTitles];
    if ([sectionTitles count] > section) {
        NSString *sectionTitle = sectionTitles[section];
        
        if ([sectionTitle isEqualToString:@"At Home"]) {
            items = self.atHomeItems;
        }
        if ([sectionTitle isEqualToString:@"Away"]) {
            items = self.awayItems;
        }
        if ([sectionTitle isEqualToString:@"Borrowed"]) {
            items = self.borrowedItems;
        }
    }
    
    return [items copy];
}

@end
