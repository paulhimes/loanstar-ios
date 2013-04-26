//
//  ServerAdapter.m
//  loanstar
//
//  Created by Paul Himes on 4/24/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "ServerAdapter.h"

@implementation ServerAdapter

static NSString * const kServerBaseUrl = @"http://primatehouse.com:8086";

#pragma mark - UserAccount management

+ (void)createUserAccount:(UserAccount *)userAccount
               completion:(void (^)(UserAccount *confirmedUserAccount, NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/user/create" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
        confirmedUserAccount.email = userAccount.email;
        confirmedUserAccount.displayName = userAccount.displayName;
        confirmedUserAccount.userId = responseDictionary[@"userId"];
        completion(confirmedUserAccount, error);
    }];
}

+ (void)loginWithUserAccount:(UserAccount *)userAccount
                  completion:(void (^)(UserAccount *confirmedUserAccount, NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/user/login" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
        confirmedUserAccount.email = userAccount.email;
        confirmedUserAccount.userId = responseDictionary[@"userId"];
        confirmedUserAccount.displayName = responseDictionary[@"displayName"];
        completion(confirmedUserAccount, nil);
    }];
}

#pragma mark - Item management

+ (void)getAllItemsWithCompletion:(void (^)(NSArray *allItems, NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/items" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        NSArray *allItems = @[];
        completion(allItems, error);
    }];
}

+ (void)getAllItemsOwnedByUserAccount:(UserAccount*)userAccount
                           completion:(void (^)(NSArray *items, NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/user/items" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        NSArray *items = @[];
        completion(items, error);
    }];
}

+ (void)createItem:(Item *)item
        completion:(void (^)(Item *confirmedItem, NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/create" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        Item *confirmedItem = item;
        completion(confirmedItem, error);
    }];
}

+ (void)editItem:(Item *)item
      completion:(void (^)(NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/update" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        completion(error);
    }];
}

+ (void)deleteItem:(Item *)item
        completion:(void (^)(NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/delete" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        completion(error);
    }];
}

#pragma mark - Borrow management

+ (void)createBorrow:(Borrow *)borrow
          completion:(void (^)(Borrow *confirmedBorrow, NSError *error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/create" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        Borrow *confirmedBorrow = borrow;
        completion(confirmedBorrow, error);
    }];
}

+ (void)editBorrow:(Borrow *)borrow
        completion:(void (^)(NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/update" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        completion(error);
    }];
}

+ (void)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount
                                        completion:(void (^)(NSArray *items, NSError* error))completion
{
    [self requestDictionaryFromAPIEndpoint:@"api/user/requests" withCompletion:^(NSDictionary *responseDictionary, NSError *error) {
        NSArray *items = @[];
        completion(items, error);
    }];
}

#pragma mark - Helper methods

+ (NSURL*)urlForEndpoint:(NSString*)endPoint
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kServerBaseUrl, endPoint]];
}

+ (NSDictionary*)requestDictionaryFromAPIEndpoint:(NSString*)endpoint error:(NSError **)error
{
    // Setup the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[self urlForEndpoint:endpoint]];
    
    // Make the request and get the response.
    NSURLResponse *response;
        
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    
    // Convert the response to objective c objects.
    return [NSJSONSerialization JSONObjectWithData:responseData options:0 error:error];
}

+ (void)requestDictionaryFromAPIEndpoint:(NSString*)endpoint
                          withCompletion:(void (^)(NSDictionary *responseDictionary, NSError *error))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // This code will run on a background thread.
        
        // Make the request.
        NSError *error;
        NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:endpoint error:&error];
        
        NSLog(@"%@", responseDictionary);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(responseDictionary, error);
        });
    });
}

@end
