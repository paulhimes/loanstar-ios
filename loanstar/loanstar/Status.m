//
//  Status.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Status.h"
#import "Borrow.h"

@implementation Status
@synthesize borrows = _borrows;

static NSString * const kRequested = @"Requested";
static NSString * const kCancelled = @"Cancelled";
static NSString * const kAccepted = @"Accepted";
static NSString * const kDenied = @"Denied";
static NSString * const kReturned = @"Returned";
static NSMutableDictionary *typeDictionary;

- (NSArray *)borrows
{
    if (!_borrows) {
        _borrows = @[];
    }
    
    return _borrows;
}

- (void)addBorrow:(Borrow*)borrow
{
    if (![self.borrows containsObject:borrow]) {
        _borrows = [self.borrows arrayByAddingObject:borrow];
        borrow.status = self;
    }
}

- (void)removeBorrow:(Borrow*)borrow
{
    if ([self.borrows containsObject:borrow]) {
        NSMutableArray *mutableCopy = [self.borrows mutableCopy];
        [mutableCopy removeObject:borrow];
        _borrows = mutableCopy;
    }
}

+ (Status*)statusForType:(NSString*)type
{
    if (!typeDictionary) {
        typeDictionary = [NSMutableDictionary dictionary];
    }
    if (!typeDictionary[type]) {
        Status *status = [[Status alloc] init];
        status.name = type;
        
        typeDictionary[type] = status;
    }
    
    return typeDictionary[type];
}

+ (Status*)requested
{
    return [Status statusForType:kRequested];
}

+ (Status*)cancelled
{
    return [Status statusForType:kCancelled];
}

+ (Status*)accepted
{
    return [Status statusForType:kAccepted];
}

+ (Status*)denied
{
    return [Status statusForType:kDenied];
}

+ (Status*)returned
{
    return [Status statusForType:kReturned];
}

@end
