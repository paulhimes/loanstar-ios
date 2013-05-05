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
@synthesize items = _items;

static NSString * const kVHS = @"VHS";
static NSString * const kDVD = @"DVD";
static NSString * const kBluray = @"Blu-ray";
static NSMutableDictionary *typeDictionary;

- (NSArray *)items
{
    if (!_items) {
        _items = @[];
    }
    
    return _items;
}

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

+ (NSArray*)allFormats
{
    return @[[self dvd], [self bluray], [self vhs]];
}

+ (Format*)formatForString:(NSString*)formatString
{
    Format *format;
    if ([formatString isEqualToString:@"Blu-ray"]) {
        format = [self bluray];
    } else if ([formatString isEqualToString:@"DVD"]) {
        format = [self dvd];
    } else if ([formatString isEqualToString:@"VHS"]) {
        format = [self vhs];
    }
    
    return format;
}

- (NSString *)description
{
    NSString *string;
    if ([self isEqual:[Format bluray]]) {
        string = @"Blu-ray";
    } else if ([self isEqual:[Format dvd]]) {
        string = @"DVD";
    } else if ([self isEqual:[Format vhs]]) {
        string = @"VHS";
    }
    
    return string;
}

@end
