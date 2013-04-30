//
//  Borrow.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Status;
@class UserAccount;
@class Item;

@interface Borrow : NSObject

@property (nonatomic, strong) NSDate *requestDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) UserAccount *borrower;
@property (nonatomic, strong) Item *item;
@property (nonatomic, strong) Status *status;

- (BOOL)isActive;

@end
