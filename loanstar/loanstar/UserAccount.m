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

static NSString * const kCurrentUserId = @"CurrentUserId";
static NSString * const kCurrentEmail = @"CurrentEmail";
static NSString * const kCurrentDisplayName = @"CurrentDisplayName";

@implementation UserAccount
@synthesize items = _items;
@synthesize borrows = _borrows;

- (NSArray *)items
{
    if (!_items) {
        _items = @[];
    }
    
    return _items;
}

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

- (NSArray *)borrows
{
    if (!_borrows) {
        _borrows = @[];
    }
    
    return _borrows;
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

- (BOOL)isEqual:(id)object
{
    BOOL equal = NO;
    
    if ([object isKindOfClass:[UserAccount class]]) {
        UserAccount *otherUserAccount = (UserAccount*)object;
        
        equal = [self.userId isEqualToString:otherUserAccount.userId];
    }
    
    return equal;
}

+ (UserAccount*)currentUserAccount
{
    UserAccount *currentAccount;
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId] length] > 0) {
        currentAccount = [[UserAccount alloc] init];
        currentAccount.userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
        currentAccount.email = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentEmail];
        currentAccount.displayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    }
    return currentAccount;
}

+ (void)setCurrentUserAccount:(UserAccount*)userAccount
{
    if (userAccount) {
        [[NSUserDefaults standardUserDefaults] setValue:userAccount.email forKey:kCurrentEmail];
        [[NSUserDefaults standardUserDefaults] setValue:userAccount.userId forKey:kCurrentUserId];
        [[NSUserDefaults standardUserDefaults] setValue:userAccount.displayName forKey:kCurrentDisplayName];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserId];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)lastUsedEmail
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentEmail];
}

- (NSDictionary*)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (self.userId) {
        dictionary[@"userId"] = self.userId;
    }
    if (self.displayName) {
        dictionary[@"displayName"] = self.displayName;
    }
    if (self.email) {
        dictionary[@"email"] = self.email;
    }
    if (self.hashedPassword) {
        dictionary[@"hashedPassword"] = self.hashedPassword;
    }
    return [dictionary copy];
}

+ (UserAccount*)fromDictionary:(NSDictionary*)dictionary
{
    UserAccount *userAccount;
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        userAccount = [[UserAccount alloc] init];
        userAccount.userId = [dictionary[@"userId"] description];
        userAccount.displayName = dictionary[@"displayName"];
        userAccount.email = dictionary[@"email"];
        userAccount.hashedPassword = dictionary[@"hashedPassword"];
    }
    return userAccount;
}

@end
