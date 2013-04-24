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
@synthesize sectionTitles = _sectionTitles;

- (NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        _sectionTitles = @[@"At Home", @"Away", @"Borrowed"];
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
        items = @[[Item itemWithTitle:@"Serenity" year:2005 format:[Format vhs]],
                  [Item itemWithTitle:@"The Dark Crystal" year:1982 format:[Format vhs]]];
        ((Item*)items[0]).owner = userAccount;
        ((Item*)items[1]).owner = userAccount;
    } else if (section == 1) {
        items = @[[Item itemWithTitle:@"Star Wars" year:1977 format:[Format bluray]]];
        ((Item*)items[0]).owner = userAccount;
    } else {
        items = @[];
    }
    
    return items;
}

@end
