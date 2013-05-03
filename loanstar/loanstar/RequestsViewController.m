//
//  RequestsViewController.m
//  loanstar
//
//  Created by Paul Himes on 4/22/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@property (nonatomic, strong) NSMutableArray *myRequests;
@property (nonatomic, strong) NSMutableArray *othersRequests;

@end

@implementation RequestsViewController
@synthesize sectionTitles = _sectionTitles;

- (void)loadItems
{
    [self.myRequests removeAllObjects];
    [self.othersRequests removeAllObjects];

    NSDictionary *items = [ServerAdapter getAllItemsWithBorrowsRelatedToUserAccount:[UserAccount currentUserAccount]];
    
    // My Requests
    for (Item *item in items[@"myRequests"]) {
        for (Borrow *borrow in item.borrows) {
            if (![borrow isActive] && [borrow.borrower isEqual:[UserAccount currentUserAccount]]) {
                [self.myRequests addObject:item];
                break;
            }
        }
    }
    // Requests from others
    for (Item *item in items[@"requestsFromOthers"]) {
        for (Borrow *borrow in item.borrows) {
            if (![borrow isActive] && [borrow.item.owner isEqual:[UserAccount currentUserAccount]]) {
                [self.othersRequests addObject:item];
                break;
            }
        }
    }
}

- (NSMutableArray *)myRequests
{
    if (!_myRequests) {
        _myRequests = [NSMutableArray array];
    }
    return _myRequests;
}

- (NSMutableArray *)othersRequests
{
    if (!_othersRequests) {
        _othersRequests = [NSMutableArray array];
    }
    return _othersRequests;
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
    NSMutableArray *items = [NSMutableArray array];
    
    if (section == 0) {
        items = self.myRequests;
    } else if (section == 1) {
        items = self.othersRequests;
    }
    
    return [items copy];
}

@end
