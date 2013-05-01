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



+ (UserAccount *)createUserAccount:(UserAccount *)userAccount error:(NSError **)error
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/user/create" jsonData:nil error:error];
    
    UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
    confirmedUserAccount.email = userAccount.email;
    confirmedUserAccount.displayName = userAccount.displayName;
    confirmedUserAccount.userId = responseDictionary[@"userId"];
    return confirmedUserAccount;
}

+ (UserAccount *)loginWithUserAccount:(UserAccount *)userAccount error:(NSError **)error
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/login" jsonData:nil error:error];
    UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
    confirmedUserAccount.email = userAccount.email;
    confirmedUserAccount.userId = responseDictionary[@"userId"];
    confirmedUserAccount.displayName = responseDictionary[@"displayName"];
    return confirmedUserAccount;
}

#pragma mark - Item management

+ (NSArray *)getAllItemsWithError:(NSError **)error
{
    [self requestDictionaryFromAPIEndpoint:@"api/items" jsonData:nil error:error];
    return @[];
}

+ (NSArray *)getAllItemsNotOwnedOrBorrowedByUserAccount:(UserAccount *)userAccount error:(NSError **)error
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/items?userId=%@", userAccount.userId] jsonData:nil error:error];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDictionary in responseDictionary[@"itemList"]) {
        Item *item = [Item fromDictionary:itemDictionary];
        
        for (NSDictionary *borrowDictionary in itemDictionary[@"borrows"]) {
            Borrow *borrow = [Borrow fromDictionary:borrowDictionary];
            borrow.borrower = [UserAccount fromDictionary:borrowDictionary[@"userAccount"]];
            [item addBorrow:borrow];
        }
        
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

+ (NSArray *)getAllItemsOwnedByUserAccount:(UserAccount *)userAccount error:(NSError **)error
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:[NSString stringWithFormat:@"api/items/owned?userId=%@", userAccount.userId] jsonData:nil error:error];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDictionary in responseDictionary[@"itemList"]) {
        Item *item = [Item fromDictionary:itemDictionary];
        item.owner = userAccount;
        [items addObject:item];
        for (NSDictionary *borrowDictionary in itemDictionary[@"borrows"]) {
            Borrow *borrow = [Borrow fromDictionary:borrowDictionary];
            borrow.borrower = [UserAccount fromDictionary:borrowDictionary[@"userAccount"]];
            [item addBorrow:borrow];
        }
    }
    return items;
}

+ (Item *)createItem:(Item *)item error:(NSError **)error
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/create" jsonData:nil error:error];
    return item;
}

+ (void)editItem:(Item *)item error:(NSError **)error
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/update" jsonData:nil error:error];
}

+ (void)deleteItem:(Item *)item error:(NSError **)error
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/delete" jsonData:nil error:error];
}

#pragma mark - Borrow management

+ (Borrow *)createBorrow:(Borrow *)borrow error:(NSError **)error
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/create" jsonData:nil error:error];
    return borrow;
}

+ (void)editBorrow:(Borrow *)borrow error:(NSError **)error
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/update" jsonData:nil error:error];
}

+ (NSArray *)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount error:(NSError **)error
{
     [self requestDictionaryFromAPIEndpoint:@"api/user/requests" jsonData:nil error:error];
     return @[];
}

#pragma mark - Helper methods

+ (NSURL*)urlForEndpoint:(NSString*)endPoint
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerBaseUrl, endPoint]];
}

+ (NSDictionary*)requestDictionaryFromAPIEndpoint:(NSString*)endpoint jsonData:(NSData*)jsonData error:(NSError **)error
{
    // Setup the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self urlForEndpoint:endpoint]];
    
    if (jsonData) {
        [request setHTTPMethod:@"GET"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
    }
    
    NSLog(@"sending: %@", request);
    
    // Make the request and get the response.
    NSURLResponse *response;
        
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    
    // Convert the response to objective c objects.
    NSDictionary *responseDictionary;
    if (responseData) {
        responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:error];
    }
    
    NSLog(@"%@", responseDictionary);
    if (error) {
        NSLog(@"%@", *error);
    }
    
    return responseDictionary;
}

@end
