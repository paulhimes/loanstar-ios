//
//  Theme.m
//  loanstar
//
//  Created by Paul Himes on 4/23/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Theme.h"

@implementation Theme

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:0.73 green:0.93 blue:0.77 alpha:1.0];
}

+ (UIColor *)titleColor
{
    return [UIColor colorWithRed:1 green:0.97 blue:0 alpha:1.0];
}

+ (UIColor *)navigationBarColor
{
    return [UIColor colorWithRed:0.14 green:0.57 blue:0.24 alpha:1.0];
}

+ (UIColor *)navigationTitleColor
{
    return [UIColor colorWithRed:0.40 green:0.88 blue:0.50 alpha:1.0];
}

+ (UIFont *)navigationTitleFont
{
    return [UIFont fontWithName:@"Copperplate" size:22];
}

+ (UIFont *)bodyTextFont
{
    return [UIFont fontWithName:@"Futura-Medium" size:17];
}

+ (UIFont *)bodyTextSmallFont
{
    return [UIFont fontWithName:@"Futura-Medium" size:14];
}

@end
