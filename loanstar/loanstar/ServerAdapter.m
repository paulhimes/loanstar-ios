//
//  ServerAdapter.m
//  loanstar
//
//  Created by Paul Himes on 4/24/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ServerAdapter.h"
#import "Item.h"
#import "Format.h"
#import "Borrow.h"

@implementation ServerAdapter

static NSString * const kServerBaseUrl = @"http://primatehouse.com:8086";

#pragma mark - UserAccount management


// done
+ (UserAccount *)createUserAccount:(UserAccount *)userAccount
{
    NSDictionary *jsonDataDictionary = @{@"email": userAccount.email, @"hashedPassword": userAccount.hashedPassword, @"displayName": userAccount.displayName};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDataDictionary options:0 error:NULL];
    
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/user/create" jsonData:jsonData debug:NO];
    
    UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
    confirmedUserAccount.email = userAccount.email;
    confirmedUserAccount.displayName = userAccount.displayName;
    confirmedUserAccount.userId = [responseDictionary[@"userId"] description];
    return confirmedUserAccount;
}

// done
+ (UserAccount *)loginWithUserAccount:(UserAccount *)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/user/login?email=%@&hashedPassword=%@", userAccount.email, userAccount.hashedPassword] jsonData:nil debug:NO];
    UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
    confirmedUserAccount.email = userAccount.email;
    confirmedUserAccount.userId = [responseDictionary[@"userId"] description];
    confirmedUserAccount.displayName = responseDictionary[@"displayName"];
    return confirmedUserAccount;
}

#pragma mark - Item management

+ (NSArray *)getAllItems
{
    [self requestDictionaryFromAPIEndpoint:@"api/items" jsonData:nil debug:NO];
    return @[];
}

// done
+ (NSArray *)getAllItemsNotOwnedOrBorrowedByUserAccount:(UserAccount *)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/items?userId=%@", userAccount.userId] jsonData:nil debug:NO];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDictionary in responseDictionary[@"itemList"]) {
        Item *item = [self fullyLinkedItemFromDictionary:itemDictionary];
        
        // Only include items which this user does not own and is not actively borrowing.
        BOOL isBorrowing = NO;
        for (Borrow *borrow in item.borrows) {
            if ([borrow isActive] && [borrow.borrower isEqual:userAccount]) {
                isBorrowing = YES;
                break;
            }
        }
        
        if (!isBorrowing) {
            [items addObject:item];
        }
    }
    return items;
}

// done
+ (NSArray *)getAllItemsOwnedByUserAccount:(UserAccount *)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/items/owned?userId=%@", userAccount.userId] jsonData:nil debug:NO];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDictionary in responseDictionary[@"itemList"]) {
        Item *item = [self fullyLinkedItemFromDictionary:itemDictionary];
        [items addObject:item];
    }
    return items;
}

+ (Item *)createItem:(Item *)item
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/create" jsonData:nil debug:NO];
    return item;
}

+ (void)editItem:(Item *)item
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/update" jsonData:nil debug:NO];
}

+ (void)deleteItem:(Item *)item
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/delete" jsonData:nil debug:NO];
}

#pragma mark - Borrow management

+ (Borrow *)createBorrow:(Borrow *)borrow
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/create" jsonData:nil debug:NO];
    return borrow;
}

+ (void)editBorrow:(Borrow *)borrow
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/update" jsonData:nil debug:NO];
}

// done
+ (NSDictionary *)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount
{
     NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/borrows/requests?userId=%@", userAccount.userId] jsonData:nil debug:YES];
    
    NSMutableArray *myRequests = [NSMutableArray array];
    NSMutableArray *requestsFromOthers = [NSMutableArray array];
    
    NSArray *myRequestedItemDictionaries = responseDictionary[@"requestsByList"];
    for (NSDictionary *itemDictionary in myRequestedItemDictionaries) {
        [myRequests addObject:[self fullyLinkedItemFromDictionary:itemDictionary]];
    }
    NSArray *requestedByOthersItemDictionaries = responseDictionary[@"requestsForList"];
    for (NSDictionary *itemDictionary in requestedByOthersItemDictionaries) {
        [requestsFromOthers addObject:[self fullyLinkedItemFromDictionary:itemDictionary]];
    }
    
    return @{@"myRequests": [myRequests copy], @"requestsFromOthers": [requestsFromOthers copy]};
}

// done
+ (NSArray *)getAllItemsCurrentlyBorrowedByUserAccount:(UserAccount*)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/borrows?userId=%@", userAccount.userId] jsonData:nil debug:YES];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDictionary in responseDictionary[@"itemList"]) {
        Item *item = [self fullyLinkedItemFromDictionary:itemDictionary];
        [items addObject:item];
    }
    return items;
}

#pragma mark - Helper methods

+ (NSURL*)urlForEndpoint:(NSString*)endPoint
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerBaseUrl, endPoint]];
}

+ (NSDictionary*)requestDictionaryFromAPIEndpoint:(NSString*)endpoint jsonData:(NSData*)jsonData debug:(BOOL)debug
{
    // Setup the request.
    endpoint = [endpoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self urlForEndpoint:endpoint]];
    
    if (jsonData) {
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
    }
    
    if (debug) NSLog(@"sending: %@", request);
    
    // Make the request and get the response.
    NSURLResponse *response;
        
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    // Convert the response to objective c objects.
    NSDictionary *responseDictionary;
    if (responseData) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:NULL];
    }
    
    if (debug) NSLog(@"%@", responseDictionary);
    
    return responseDictionary;
}

+ (Item*)fullyLinkedItemFromDictionary:(NSDictionary*)dictionary
{
    Item *item = [Item fromDictionary:dictionary];
    item.owner = [UserAccount fromDictionary:dictionary[@"userAccount"]];
    for (NSDictionary *borrowDictionary in dictionary[@"borrows"]) {
        Borrow *borrow = [Borrow fromDictionary:borrowDictionary];
        borrow.borrower = [UserAccount fromDictionary:borrowDictionary[@"userAccount"]];
        [item addBorrow:borrow];
    }
    return item;
}

@end
