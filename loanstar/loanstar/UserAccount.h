//
//  UserAccount.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;
@class Borrow;

@interface UserAccount : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *hashedPassword;

@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSArray *borrows;

- (void)addItem:(Item*)item;
- (void)removeItem:(Item*)item;
- (void)addBorrow:(Borrow*)borrow;
- (void)removeBorrow:(Borrow*)borrow;

+ (UserAccount*)currentUserAccount;
+ (void)setCurrentUserAccount:(UserAccount*)userAccount;
+ (NSString*)lastUsedEmail;

- (NSDictionary*)dictionary;
+ (UserAccount*)fromDictionary:(NSDictionary*)dictionary;

@end
