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

- (NSArray*)topSectionItems
{
    NSArray *items = @[[Item itemWithTitle:@"Jurassic Park" year:1993 format:[Format vhs]],
                       [Item itemWithTitle:@"Serenity" year:2005 format:[Format vhs]],
                       [Item itemWithTitle:@"The Matrix" year:1999 format:[Format dvd]],
                       [Item itemWithTitle:@"The Dark Crystal" year:1982 format:[Format vhs]]];
    
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = @"Paul";
    userAccount.userId = userAccount.displayName;
    ((Item*)items[0]).owner = userAccount;
    
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    UserAccount *currentUserAccount = [[UserAccount alloc] init];
    currentUserAccount.displayName = currentDisplayName;
    currentUserAccount.userId = currentUserId;
    ((Item*)items[1]).owner = currentUserAccount;
    
    UserAccount *otherUserAccount = [[UserAccount alloc] init];
    otherUserAccount.displayName = @"Bob";
    otherUserAccount.userId = otherUserAccount.displayName;
    ((Item*)items[2]).owner = otherUserAccount;
    

    ((Item*)items[3]).owner = currentUserAccount;
    
    return items;
}

- (NSArray*)bottomSectionItems
{
    NSArray *items = @[[Item itemWithTitle:@"Raiders of the Lost Ark" year:1981 format:[Format dvd]],
                       [Item itemWithTitle:@"Star Wars" year:1977 format:[Format bluray]]];
    
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    UserAccount *currentUserAccount = [[UserAccount alloc] init];
    currentUserAccount.displayName = currentDisplayName;
    currentUserAccount.userId = currentUserId;
    ((Item*)items[1]).owner = currentUserAccount;
    
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = @"Bob";
    userAccount.userId = userAccount.displayName;
    ((Item*)items[0]).owner = userAccount;
    
    return items;
}

@end
