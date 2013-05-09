//
//  Theme.m
//  loanstar
//
//  Created by Paul Himes on 4/23/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import "Theme.h"

@implementation Theme

// Reused Colors

+ (UIColor *)gold
{
    return [UIColor colorWithRed:1 green:0.97 blue:0 alpha:1.0];
}

+ (UIColor *)darkGreen
{
    return [UIColor colorWithRed:0.14 green:0.57 blue:0.24 alpha:1.0];
}

+ (UIColor *)translucentDarkGreen
{
    return [UIColor colorWithRed:0.14 green:0.57 blue:0.24 alpha:0.5];
}

+ (UIColor *)darkerGreen
{
    return [UIColor colorWithRed:0.0 green:0.49 blue:0.11 alpha:1.0];
}

+ (UIColor *)darkestGreen
{
    return [UIColor colorWithRed:0.0 green:0.25 blue:0.05 alpha:1.0];
}

+ (UIColor *)lightGreen
{
    return [UIColor colorWithRed:0.40 green:0.88 blue:0.50 alpha:1.0];
}


// General

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:0.78 green:1.0 blue:0.82 alpha:1.0];
}


// Navigation

+ (UIColor *)navigationBarColor
{
    return [Theme darkGreen];
}

+ (UIColor *)navigationTitleColor
{
    return [Theme gold];
}

+ (UIColor *)navigationTitleInactiveColor
{
    return [Theme lightGreen];
}

+ (UIFont *)navigationTitleFont
{
    return [UIFont fontWithName:@"Copperplate" size:22];
}

+ (UIFont *)tabItemFont
{
    return [UIFont fontWithName:@"Copperplate-Bold" size:12];
}


// Content titles

+ (UIFont *)titleFont
{
    return [UIFont fontWithName:@"Futura-Medium" size:17];
}

+ (UIColor *)titleColor
{
    return [Theme darkestGreen];
}


// Content subtitles

+ (UIFont *)subtitleFont
{
    return [UIFont fontWithName:@"Futura-Medium" size:14];
}

+ (UIColor *)subtitleColor
{
    return [Theme darkerGreen];
}


// Table Header

+ (UIColor *)tableHeaderColor
{
    return [Theme translucentDarkGreen];
}

@end
