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
