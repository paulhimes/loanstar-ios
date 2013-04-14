//
//  Format.m
//  loanstar
//
//  Created by Paul Himes on 4/12/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Format.h"
#import "Item.h"

@implementation Format

static NSString * const kVHS = @"VHS";
static NSString * const kDVD = @"DVD";
static NSString * const kBluray = @"Bluray";
static NSMutableDictionary *typeDictionary;

- (void)addItem:(Item*)item
{
    if (![self.items containsObject:item]) {
        _items = [self.items arrayByAddingObject:item];
        item.format = self;
    }
}

- (void)removeItem:(Item*)item
{
    if ([self.items containsObject:item]) {
        NSMutableArray *mutableCopy = [self.items mutableCopy];
        [mutableCopy removeObject:item];
        _items = mutableCopy;
    }
}

+ (Format*)formatForType:(NSString*)type
{
    if (!typeDictionary) {
        typeDictionary = [NSMutableDictionary dictionary];
    }
    if (!typeDictionary[type]) {
        Format *format = [[Format alloc] init];
        format.name = type;
        
        typeDictionary[type] = format;
    }
    
    return typeDictionary[type];
}

+ (Format*)vhs
{
    return [Format formatForType:kVHS];
}

+ (Format*)dvd
{
    return [Format formatForType:kDVD];
}

+ (Format*)bluray
{
    return [Format formatForType:kBluray];
}

@end
