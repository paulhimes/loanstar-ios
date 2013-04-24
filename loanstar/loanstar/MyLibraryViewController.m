//
//  MyLibraryViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "MyLibraryViewController.h"

@interface MyLibraryViewController ()

@end

@implementation MyLibraryViewController

- (NSArray*)topSectionItems
{
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    
    NSArray *items = @[[Item itemWithTitle:@"Serenity" year:2005 format:[Format vhs]],
                       [Item itemWithTitle:@"The Dark Crystal" year:1982 format:[Format vhs]]];
    
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = currentDisplayName;
    userAccount.userId = currentUserId;
    ((Item*)items[0]).owner = userAccount;
    ((Item*)items[1]).owner = userAccount;
    
    return items;
}

- (NSArray*)bottomSectionItems
{
    NSString *currentDisplayName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentDisplayName];
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserId];
    
    NSArray *items = @[[Item itemWithTitle:@"Star Wars" year:1977 format:[Format bluray]]];
    UserAccount *userAccount = [[UserAccount alloc] init];
    userAccount.displayName = currentDisplayName;
    userAccount.userId = currentUserId;
    ((Item*)items[0]).owner = userAccount;
    return items;
}

@end
