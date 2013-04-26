//
//  RequestsViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    UserAccount *currentAccount = [[UserAccount alloc] init];
    currentAccount.userId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    [ServerAdapter getAllItemsWithBorrowsRelatedToUserAccount:currentAccount completion:^(NSArray *items, NSError *error) {
        self.items = items;
    }];
}

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[@"My Requests", @"Requests From Others"];
    }
    
    return _sectionTitles;
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    NSArray *items;
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = currentDisplayName;
    userAccount.userId = currentUserId;
    if (section == 0) {
        items = @[[Item itemWithTitle:@"The Matrix" year:1999 format:[Format dvd]]];
        
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.displayName = @"Bob";
        userAccount.userId = userAccount.displayName;
        
        ((Item*)items[0]).owner = userAccount;
    } else if (section == 1) {
        items = @[[Item itemWithTitle:@"Star Wars" year:1977 format:[Format bluray]]];
        ((Item*)items[0]).owner = userAccount;
    } else {
        items = @[];
    }
    
    return items;
}

- (NSArray*)topSectionItems
{
    NSArray *items = @[[Item itemWithTitle:@"The Matrix" year:1999 format:[Format dvd]]];
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = @"Bob";
    userAccount.userId = userAccount.displayName;
    ((Item*)items[0]).owner = userAccount;
    
    return items;
}

- (NSArray*)bottomSectionItems
{
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    
    NSArray *items = @[[Item itemWithTitle:@"The Dark Crystal" year:1982 format:[Format vhs]]];
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = currentDisplayName;
    userAccount.userId = currentUserId;
    ((Item*)items[0]).owner = userAccount;
    return items;
}

@end
