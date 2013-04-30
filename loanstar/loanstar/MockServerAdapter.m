//
//  MockServerAdapter.m
//  loanstar
//
//  Created by Paul Himes on 4/28/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "MockServerAdapter.h"
#import "Item.h"
#import "Format.h"
#import "Borrow.h"

@implementation MockServerAdapter

+ (NSArray *)allItems
{
    // Create all the placeholder items.
    NSMutableArray *items = [NSMutableArray array];
    
    
    Item *itemOne = [[Item alloc] init];
    itemOne.title = @"Rudy";
    itemOne.year = 1993;
    itemOne.format = [Format vhs];
    itemOne.owner = [self bob];
    [items addObject:itemOne];
    
    
    Item *itemTwo = [[Item alloc] init];
    itemTwo.title = @"Jurassic Park";
    itemTwo.year = 1993;
    itemTwo.format = [Format dvd];
    itemTwo.owner = [self bob];
    [items addObject:itemTwo];
    
    Borrow *borrowTwo = [[Borrow alloc] init];
    borrowTwo.borrower = [self chad];
    borrowTwo.requestDate = [self relativeDateInDaysFromNow:-2];
    borrowTwo.startDate = [self relativeDateInDaysFromNow:-1];
    borrowTwo.item = itemTwo;
    
    
    Item *itemThree = [[Item alloc] init];
    itemThree.title = @"Serenity";
    itemThree.year = 2005;
    itemThree.format = [Format bluray];
    itemThree.owner = [self bob];
    [items addObject:itemThree];
    
    Borrow *borrowThree = [[Borrow alloc] init];
    borrowThree.borrower = [self paul];
    borrowThree.requestDate = [self relativeDateInDaysFromNow:-2];
    borrowThree.startDate = [self relativeDateInDaysFromNow:-1];
    borrowThree.item = itemThree;
    
    
    Item *itemFour = [[Item alloc] init];
    itemFour.title = @"Terminator";
    itemFour.year = 1984;
    itemFour.format = [Format vhs];
    itemFour.owner = [self bob];
    [items addObject:itemFour];
    
    Borrow *borrowFour = [[Borrow alloc] init];
    borrowFour.borrower = [self paul];
    borrowFour.requestDate = [self relativeDateInDaysFromNow:-1];
    borrowFour.item = itemFour;
    
    
    Item *itemFive = [[Item alloc] init];
    itemFive.title = @"The Matrix";
    itemFive.year = 1999;
    itemFive.format = [Format dvd];
    itemFive.owner = [self bob];
    [items addObject:itemFive];
    
    Borrow *borrowFive = [[Borrow alloc] init];
    borrowFive.borrower = [self chad];
    borrowFive.requestDate = [self relativeDateInDaysFromNow:-4];
    borrowFive.startDate = [self relativeDateInDaysFromNow:-2];
    borrowFive.item = itemFive;
    
    Borrow *borrowFiveB = [[Borrow alloc] init];
    borrowFiveB.borrower = [self paul];
    borrowFiveB.requestDate = [self relativeDateInDaysFromNow:-3];
    borrowFiveB.item = itemFive;
    
    
    Item *itemSix = [[Item alloc] init];
    itemSix.title = @"The Dark Crystal";
    itemSix.year = 1982;
    itemSix.format = [Format bluray];
    itemSix.owner = [self paul];
    [items addObject:itemSix];
    
    
    Item *itemSeven = [[Item alloc] init];
    itemSeven.title = @"Raiders of the Lost Ark";
    itemSeven.year = 1981;
    itemSeven.format = [Format vhs];
    itemSeven.owner = [self paul];
    [items addObject:itemSeven];
    
    Borrow *borrowSeven = [[Borrow alloc] init];
    borrowSeven.borrower = [self bob];
    borrowSeven.requestDate = [self relativeDateInDaysFromNow:-2];
    borrowSeven.item = itemSeven;
    
    
    Item *itemEight = [[Item alloc] init];
    itemEight.title = @"Star Wars";
    itemEight.year = 1977;
    itemEight.format = [Format dvd];
    itemEight.owner = [self paul];
    [items addObject:itemEight];
    
    Borrow *borrowEight = [[Borrow alloc] init];
    borrowEight.borrower = [self bob];
    borrowEight.requestDate = [self relativeDateInDaysFromNow:-2];
    borrowEight.startDate = [self relativeDateInDaysFromNow:-1];
    borrowEight.item = itemEight;
    
    
    return [items copy]; // Return an immutable copy.
}

+ (UserAccount *)paul
{
    UserAccount *paul = [[UserAccount alloc] init];
    paul.userId = @"paul";
    paul.email = @"paul@paulhimes.com";
    paul.displayName = @"Paul Himes";
    return paul;
}

+ (UserAccount *)bob
{
    UserAccount *bob = [[UserAccount alloc] init];
    bob.userId = @"bob";
    bob.email = @"redusek@gmail.com";
    bob.displayName = @"Bob Dusek";
    return bob;
}

+ (UserAccount *)chad
{
    UserAccount *chad = [[UserAccount alloc] init];
    chad.userId = @"chad";
    chad.email = @"chadmlinke@gmail.com";
    chad.displayName = @"Chad Linke";
    return chad;
}

#pragma mark - UserAccount management

+ (void)createUserAccount:(UserAccount *)userAccount
               completion:(void (^)(UserAccount *confirmedUserAccount, NSError* error))completion
{
    completion([self paul], nil);
}

+ (void)loginWithUserAccount:(UserAccount *)userAccount
                  completion:(void (^)(UserAccount *confirmedUserAccount, NSError* error))completion
{
    completion([self paul], nil);
}

#pragma mark - Item management

+ (void)getAllItemsWithCompletion:(void (^)(NSArray *allItems, NSError* error))completion
{
    completion([self allItems], nil);
}

+ (void)getAllItemsNotOwnedOrBorrowedByUserAccount:(UserAccount*)userAccount completion:(void (^)(NSArray *items, NSError *error))completion
{
    NSMutableArray *items = [NSMutableArray array];
    for (Item *item in [self allItems]) {
        if (![item.owner.userId isEqualToString:userAccount.userId]) {
            // The user account does not own this item.
            BOOL isBorrowedByUser = NO;
            for (Borrow *borrow in item.borrows) {
                if ([borrow.borrower.userId isEqualToString:userAccount.userId] && [borrow isActive]) {
                    isBorrowedByUser = YES;
                    break;
                }
            }
            if (!isBorrowedByUser) {
                [items addObject:item];
            }
        }
    }
    completion([items copy], nil);
}

+ (void)getAllItemsOwnedByUserAccount:(UserAccount*)userAccount
                           completion:(void (^)(NSArray *items, NSError* error))completion
{
    NSMutableArray *items = [NSMutableArray array];
    for (Item *item in [self allItems]) {
        if ([item.owner.userId isEqualToString:userAccount.userId]) {
            [items addObject:item];
        }
    }
    completion([items copy], nil);
}

+ (void)createItem:(Item *)item
        completion:(void (^)(Item *confirmedItem, NSError* error))completion
{
    completion(item, nil);
}

+ (void)editItem:(Item *)item
      completion:(void (^)(NSError* error))completion
{
    completion(nil);
}

+ (void)deleteItem:(Item *)item
        completion:(void (^)(NSError* error))completion
{
    completion(nil);
}

#pragma mark - Borrow management

+ (void)createBorrow:(Borrow *)borrow
          completion:(void (^)(Borrow *confirmedBorrow, NSError *error))completion
{
    completion(borrow, nil);
}

+ (void)editBorrow:(Borrow *)borrow
        completion:(void (^)(NSError* error))completion
{
    completion(nil);
}

+ (void)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount
                                        completion:(void (^)(NSArray *items, NSError* error))completion
{
    NSMutableArray *items = [NSMutableArray array];
    for (Item *item in [self allItems]) {
        for (Borrow *borrow in item.borrows) {
            if ([borrow.item.owner.userId isEqualToString:userAccount.userId] ||
                [borrow.borrower.userId isEqualToString:userAccount.userId]) {
                if (![items containsObject:item]) {
                    [items addObject:item];
                }
            }
        }
    }
    completion([items copy], nil);
}

#pragma mark - Helper methods

+ (NSDate*)relativeDateInDaysFromNow:(NSInteger)days
{
    double secondsPerDay = 60 * 60 * 24;
    return [NSDate dateWithTimeInterval:secondsPerDay * days sinceDate:[NSDate date]];
}

@end
