//
//  Item.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Item.h"
#import "Borrow.h"
#import "Format.h"
#import "UserAccount.h"

@implementation Item

+ (Item*)itemWithTitle:(NSString*)title
                  year:(NSUInteger)year
                format:(Format*)format
{
    Item *item = [[Item alloc] init];
    item.title = title;
    item.year = year;
    item.format = format;
    
    return item;
}

- (void)setFormat:(Format *)format
{
    if (_format != format) {
        _format = format;
        [_format addItem:self];
    }
}

- (void)setOwner:(UserAccount *)owner
{
    if (_owner != owner) {
        _owner = owner;
        [_owner addItem:self];
    }
}

- (void)addBorrow:(Borrow*)borrow
{
    if (![self.borrows containsObject:borrow]) {
        _borrows = [self.borrows arrayByAddingObject:borrow];
        _borrows = [_borrows sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((Borrow*) obj1).requestDate compare:((Borrow*) obj2).requestDate];
        }];
        borrow.item = self;
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
