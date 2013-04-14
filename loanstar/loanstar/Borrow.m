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

@end
