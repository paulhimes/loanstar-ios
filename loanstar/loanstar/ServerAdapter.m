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

typedef enum kHTTPMethod : NSUInteger {
    kGET,
    kPOST,
    kPUT,
    kDELETE
} kHTTPMethod;

@implementation ServerAdapter

static NSString * const kServerBaseUrl = @"http://primatehouse.com:8086";

#pragma mark - UserAccount management


// done
+ (UserAccount *)createUserAccount:(UserAccount *)userAccount
{    
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/user/create"
                                                               dataDictionary:@{@"email": userAccount.email, @"hashedPassword": userAccount.hashedPassword, @"displayName": userAccount.displayName}
                                                                   httpMethod:kPOST debug:NO];
    
    UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
    confirmedUserAccount.email = userAccount.email;
    confirmedUserAccount.displayName = userAccount.displayName;
    confirmedUserAccount.userId = [responseDictionary[@"userId"] description];
    return confirmedUserAccount;
}

// done
+ (UserAccount *)loginWithUserAccount:(UserAccount *)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/user/login"
                                                               dataDictionary:@{@"email": userAccount.email, @"hashedPassword": userAccount.hashedPassword}
                                                                   httpMethod:kGET
                                                                        debug:NO];
    UserAccount *confirmedUserAccount = [[UserAccount alloc] init];
    confirmedUserAccount.email = userAccount.email;
    confirmedUserAccount.userId = [responseDictionary[@"userId"] description];
    confirmedUserAccount.displayName = responseDictionary[@"displayName"];
    return confirmedUserAccount;
}

#pragma mark - Item management

// done
+ (NSArray *)getAllItemsNotOwnedOrBorrowedByUserAccount:(UserAccount *)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/items"
                                                               dataDictionary:@{@"userId": userAccount.userId}
                                                                   httpMethod:kGET
                                                                        debug:NO];
    
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
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/items/owned"
                                                               dataDictionary:@{@"userId": userAccount.userId}
                                                                   httpMethod:kGET
                                                                        debug:NO];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *itemDictionary in responseDictionary[@"itemList"]) {
        Item *item = [self fullyLinkedItemFromDictionary:itemDictionary];
        [items addObject:item];
    }
    return items;
}

+ (Item *)createItem:(Item *)item
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/item/create" dataDictionary:[item dictionary] httpMethod:kPOST debug:YES];
    return [Item fromDictionary:responseDictionary];
}

+ (void)editItem:(Item *)item
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/update" dataDictionary:[item dictionary] httpMethod:kPUT debug:NO];
}

+ (void)deleteItem:(Item *)item
{
    [self requestDictionaryFromAPIEndpoint:@"api/item/delete" dataDictionary:[item dictionary] httpMethod:kDELETE debug:YES];
}

#pragma mark - Borrow management

+ (Borrow *)createBorrow:(Borrow *)borrow
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/create" dataDictionary:nil httpMethod:kPOST debug:NO];
    return borrow;
}

+ (void)editBorrow:(Borrow *)borrow
{
    [self requestDictionaryFromAPIEndpoint:@"api/borrow/update" dataDictionary:nil httpMethod:kPUT debug:NO];
}

// done
+ (NSDictionary *)getAllItemsWithBorrowsRelatedToUserAccount:(UserAccount*)userAccount
{
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/borrows/requests"
                                                               dataDictionary:@{@"userId":userAccount.userId}
                                                                   httpMethod:kGET
                                                                        debug:NO];
    
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
    NSDictionary *responseDictionary = [self requestDictionaryFromAPIEndpoint:@"api/borrows"
                                                               dataDictionary:@{@"userId": userAccount.userId}
                                                                   httpMethod:kGET
                                                                        debug:NO];
    
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

+ (NSDictionary*)requestDictionaryFromAPIEndpoint:(NSString*)endpoint
                                   dataDictionary:(NSDictionary*)dataDictionary
                                       httpMethod:(kHTTPMethod)method
                                            debug:(BOOL)debug
{
    // Setup the request.
    if (method == kGET) {
        // Encode the data dictionary as an http query.
        NSMutableString *queryString = [NSMutableString string];
        NSUInteger index = 0;
        for (id<NSObject> key in dataDictionary) {
            [queryString appendFormat:@"%@=%@", [key description], [dataDictionary[key] description]];
            if (index < [dataDictionary count] - 1) {
                [queryString appendString:@"&"];
            }
            index++;
        }
        
        // Add the query to the endpoint path.
        endpoint = [NSString stringWithFormat:@"%@?%@", endpoint, queryString];
    }
    
    endpoint = [endpoint stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self urlForEndpoint:endpoint]];
    
    if (method == kPOST ||
        method == kPUT ||
        method == kDELETE) {
        
        // Set the request's method type.
        if (method == kPOST) {
            [request setHTTPMethod:@"POST"];
        } else if (method == kPUT) {
            [request setHTTPMethod:@"PUT"];
        } else {
            [request setHTTPMethod:@"DELETE"];
        }
        
        // Convert the data dictionary to json data.
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:NULL];
        
        // Put the json data in the body of the request.
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
    }
    
    if (debug) NSLog(@"sending: %@ with data %@", request, dataDictionary);
    
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
