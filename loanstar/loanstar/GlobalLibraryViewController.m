//
//  GlobalLibraryViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "GlobalLibraryViewController.h"

@interface GlobalLibraryViewController ()

@end

@implementation GlobalLibraryViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    [ServerAdapter getAllItemsWithCompletion:^(NSArray *allItems, NSError *error) {
        self.items = allItems;
    }];
}

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[@"Available", @"On Loan"];
    }
    
    return _sectionTitles;
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    NSArray *items;
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    UserAccount *currentUserAccount = [[UserAccount alloc] init];
    currentUserAccount.displayName = currentDisplayName;
    currentUserAccount.userId = currentUserId;
    
    if (section == 0) {
        items = @[[Item itemWithTitle:@"Jurassic Park" year:1993 format:[Format vhs]],
                  [Item itemWithTitle:@"Serenity" year:2005 format:[Format vhs]],
                  [Item itemWithTitle:@"The Matrix" year:1999 format:[Format dvd]],
                  [Item itemWithTitle:@"The Dark Crystal" year:1982 format:[Format vhs]]];
        
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.displayName = @"Paul";
        userAccount.userId = userAccount.displayName;
        
        UserAccount *otherUserAccount = [[UserAccount alloc] init];
        otherUserAccount.displayName = @"Bob";
        otherUserAccount.userId = otherUserAccount.displayName;
        
        ((Item*)items[0]).owner = userAccount;
        ((Item*)items[1]).owner = currentUserAccount;
        ((Item*)items[2]).owner = otherUserAccount;
        ((Item*)items[3]).owner = currentUserAccount;
    } else if (section == 1) {
        items = @[[Item itemWithTitle:@"Raiders of the Lost Ark" year:1981 format:[Format dvd]],
                  [Item itemWithTitle:@"Star Wars" year:1977 format:[Format bluray]]];
        
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.displayName = @"Bob";
        userAccount.userId = userAccount.displayName;
        
        ((Item*)items[0]).owner = userAccount;
        ((Item*)items[1]).owner = currentUserAccount;
    } else {
        items = @[];
    }
    
    return items;
}


@end
