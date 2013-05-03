//
//  ServerAdapter.h
//  loanstar
//
//  Created by Paul Himes on 4/24/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"

@interface ServerAdapter : NSObject

#pragma mark - UserAccount management

+ (UserAccount *)createUserAccount:(UserAccount *)userAccount;
+ (UserAccount *)loginWithUserAccount:(UserAccount *)userAccount;

#pragma mark - Item management

+ (NSArray *)getAllItemsNotOwnedOrBorrowedByUserAccount:(UserAccount *)userAccount;
+ (NSArray *)getAllItemsOwnedByUserAccount:(UserAccount *)userAccount;
+ (Item *)createItem:(Item *)item;
+ (void)editItem:(Item *)item;
+ (void)deleteItem:(Item *)item;

#pragma mark - Borrow management

+ (Borrow *)createBorrow:(Borrow *)borrow;
+ (void)editBorrow:(Borrow *)borrow;
+ (NSDictionary *)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount;
+ (NSArray *)getAllItemsCurrentlyBorrowedByUserAccount:(UserAccount*)userAccount;


@end
