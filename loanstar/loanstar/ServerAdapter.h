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

+ (void)createUserAccount:(UserAccount *)userAccount
               completion:(void (^)(UserAccount *confirmedUserAccount, NSError* error))completion;

+ (void)loginWithUserAccount:(UserAccount *)userAccount
                  completion:(void (^)(UserAccount *confirmedUserAccount, NSError* error))completion;

#pragma mark - Item management

+ (void)getAllItemsWithCompletion:(void (^)(NSArray *allItems, NSError* error))completion;

+ (void)getAllItemsOwnedByUserAccount:(UserAccount*)userAccount
                           completion:(void (^)(NSArray *items, NSError* error))completion;

+ (void)createItem:(Item *)item
        completion:(void (^)(Item *confirmedItem, NSError* error))completion;

+ (void)editItem:(Item *)item
      completion:(void (^)(NSError* error))completion;

+ (void)deleteItem:(Item *)item
        completion:(void (^)(NSError* error))completion;

#pragma mark - Borrow management

+ (void)createBorrow:(Borrow *)borrow
          completion:(void (^)(Borrow *confirmedBorrow, NSError *error))completion;

+ (void)editBorrow:(Borrow *)borrow
        completion:(void (^)(NSError* error))completion;

+ (void)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount
                                        completion:(void (^)(NSArray *items, NSError* error))completion;

@end
