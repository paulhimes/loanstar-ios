//
//  Status.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Borrow;

@interface Status : NSObject

@property (nonatomic, strong) NSString* name;

@property (nonatomic, readonly) NSArray *borrows;

- (void)addBorrow:(Borrow*)borrow;
- (void)removeBorrow:(Borrow*)borrow;

+ (Status*)requested;
+ (Status*)cancelled;
+ (Status*)accepted;
+ (Status*)denied;
+ (Status*)returned;

@end
