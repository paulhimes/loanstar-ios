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
    
    // Sort all the arrays.
    [self.myRequests sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Borrow *borrow1;
        Borrow *borrow2;
        
        for (Borrow *borrow in ((Item*)obj1).borrows) {
            // Find this user's borrow request.
            if ([borrow.borrower isEqual:[UserAccount currentUserAccount]]) {
                borrow1 = borrow;
            }
        }
        for (Borrow *borrow in ((Item*)obj1).borrows) {
            // Find this user's borrow request.
            if ([borrow.borrower isEqual:[UserAccount currentUserAccount]]) {
                borrow2 = borrow;
            }
        }
        
        return [borrow2.requestDate timeIntervalSince1970] - [borrow1.requestDate timeIntervalSince1970];
    }];
    [self.othersRequests sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Borrow *oldestBorrow1;
        Borrow *oldestBorrow2;
        
        for (Borrow *borrow in ((Item*)obj1).borrows) {
            if (!oldestBorrow1 || [borrow.requestDate compare:oldestBorrow1.requestDate] == NSOrderedAscending) {
                oldestBorrow1 = borrow;
            }
        }
        for (Borrow *borrow in ((Item*)obj1).borrows) {
            if (!oldestBorrow2 || [borrow.requestDate compare:oldestBorrow2.requestDate] == NSOrderedAscending) {
                oldestBorrow2 = borrow;
            }
        }
        
        return [oldestBorrow2.requestDate timeIntervalSince1970] - [oldestBorrow1.requestDate timeIntervalSince1970];
    }];
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
    NSMutableArray *titles = [NSMutableArray array];
    
    if ([self.myRequests count] > 0) {
        [titles addObject:@"My Requests"];
    }
    if ([self.othersRequests count] > 0) {
        [titles addObject:@"Requests From Others"];
    }
    
    return [titles copy];
}

- (NSArray *)itemsInSection:(NSUInteger)section
{
    NSArray *items = @[];
    
    NSArray *sectionTitles = [self sectionTitles];
    if ([sectionTitles count] > section) {
        NSString *sectionTitle = sectionTitles[section];
        
        if ([sectionTitle isEqualToString:@"My Requests"]) {
            items = self.myRequests;
        }
        if ([sectionTitle isEqualToString:@"Requests From Others"]) {
            items = self.othersRequests;
        }
    }
    
    return [items copy];
}

@end
