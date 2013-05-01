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

+ (UserAccount *)createUserAccount:(UserAccount *)userAccount error:(NSError **)error;
+ (UserAccount *)loginWithUserAccount:(UserAccount *)userAccount error:(NSError **)error;

#pragma mark - Item management

+ (NSArray *)getAllItemsWithError:(NSError **)error;
+ (NSArray *)getAllItemsNotOwnedOrBorrowedByUserAccount:(UserAccount *)userAccount error:(NSError **)error;
+ (NSArray *)getAllItemsOwnedByUserAccount:(UserAccount *)userAccount error:(NSError **)error;
+ (Item *)createItem:(Item *)item error:(NSError **)error;
+ (void)editItem:(Item *)item error:(NSError **)error;
+ (void)deleteItem:(Item *)item error:(NSError **)error;

#pragma mark - Borrow management

+ (Borrow *)createBorrow:(Borrow *)borrow error:(NSError **)error;
+ (void)editBorrow:(Borrow *)borrow error:(NSError **)error;
+ (NSArray *)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount error:(NSError **)error;


@end
