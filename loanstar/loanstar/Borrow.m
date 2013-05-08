//
//  Borrow.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Borrow.h"
#import "UserAccount.h"
#import "Item.h"
#import "Status.h"

@implementation Borrow

- (void)setBorrower:(UserAccount *)borrower
{
    if (_borrower != borrower) {
        _borrower = borrower;
        [_borrower addBorrow:self];
    }
}

- (void)setItem:(Item *)item
{
    if (_item != item) {
        _item = item;
        [_item addBorrow:self];
    }
}

- (void)setStatus:(Status *)status
{
    if (_status != status) {
        _status = status;
        [_status addBorrow:self];
    }
}

- (BOOL)isActive
{
    return self.startDate && [self.startDate timeIntervalSinceNow] <= 0 &&
           (!self.endDate || [self.endDate timeIntervalSinceNow] > 0);
}

- (NSString *)description
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterLongStyle;
    formatter.timeStyle = NSDateFormatterLongStyle;
    
    NSString *description = [NSString stringWithFormat:@"%@ requested to borrow %@'s copy of %@. requested=%@, started=%@, ended=%@", self.borrower.displayName, self.item.owner.displayName, self.item.title, [formatter stringFromDate:self.requestDate], [formatter stringFromDate:self.startDate], [formatter stringFromDate:self.endDate]];
    
    return description;
}

- (NSDictionary*)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.borrowId) {
        dictionary[@"borrowId"] = self.borrowId;
    }
    if (self.requestDate) {
        dictionary[@"requestDate"] = [@([self.requestDate timeIntervalSince1970]) stringValue];
    }
    if (self.startDate) {
        dictionary[@"startDate"] = [@([self.startDate timeIntervalSince1970]) stringValue];
    }
    if (self.endDate) {
        dictionary[@"endDate"] = [@([self.endDate timeIntervalSince1970]) stringValue];
    }
    if (self.item) {
        dictionary[@"itemId"] = self.item.itemId;
    }
    if (self.borrower) {
        dictionary[@"userId"] = self.borrower.userId;
    }
    return [dictionary copy];
}

+ (Borrow*)fromDictionary:(NSDictionary*)dictionary
{
    Borrow *borrow;
    if (dictionary) {
        borrow = [[Borrow alloc] init];
        borrow.borrowId = dictionary[@"borrowId"];

        if (![dictionary[@"requestDate"] isEqual:[NSNull null]]) {
            borrow.requestDate = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"requestDate"] doubleValue]];
        }
        if (![dictionary[@"startDate"] isEqual:[NSNull null]]) {
            borrow.startDate = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"startDate"] doubleValue]];
        }
    }
    return borrow;
}



@end
