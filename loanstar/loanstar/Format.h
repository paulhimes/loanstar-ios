//
//  Format.h
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface Format : NSObject

@property (nonatomic, strong) NSString* name;

@property (nonatomic, readonly) NSArray *items;

- (void)addItem:(Item*)item;
- (void)removeItem:(Item*)item;

+ (Format*)vhs;
+ (Format*)dvd;
+ (Format*)bluray;
+ (NSArray*)allFormats;

@end
