//
//  UserAccount.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "UserAccount.h"
#import "Item.h"
#import "Borrow.h"

@implementation UserAccount

- (void)addItem:(Item*)item
{
    if (![self.items containsObject:item]) {
        _items = [self.items arrayByAddingObject:item];
        item.owner = self;
    }
}

- (void)removeItem:(Item*)item
{
    if ([self.items containsObject:item]) {
        NSMutableArray *mutableCopy = [self.items mutableCopy];
        [mutableCopy removeObject:item];
        _items = mutableCopy;
    }
}

- (void)addBorrow:(Borrow*)borrow
{
    if (![self.borrows containsObject:borrow]) {
        _borrows = [self.borrows arrayByAddingObject:borrow];
        borrow.borrower = self;
    }
}

- (void)removeBorrow:(Borrow*)borrow
{
    if ([self.borrows containsObject:borrow]) {
        NSMutableArray *mutableCopy = [self.borrows mutableCopy];
        [mutableCopy removeObject:borrow];
        _borrows = mutableCopy;
    }
}

@end
