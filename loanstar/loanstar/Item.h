//
//  Item.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Format;
@class UserAccount;
@class Borrow;

@interface Item : NSObject

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString* title;
@property (nonatomic) NSUInteger year;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) NSString *pictureUrl;

@property (nonatomic, strong) Format* format;
@property (nonatomic, strong) UserAccount *owner;
@property (nonatomic, readonly) NSArray *borrows;

- (void)addBorrow:(Borrow*)borrow;
- (void)removeBorrow:(Borrow*)borrow;

+ (Item*)itemWithTitle:(NSString*)title
                  year:(NSUInteger)year
                format:(Format*)format;

- (NSDictionary*)dictionary;
+ (Item*)fromDictionary:(NSDictionary*)dictionary;

@end
