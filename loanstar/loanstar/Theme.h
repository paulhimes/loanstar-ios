//
//  Theme.h
//  loanstar
//
//  Created by Paul Himes on 4/23/13.
//  Copyright (c) 2013 MSSE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

+ (UIColor *)backgroundColor;

+ (UIColor *)navigationBarColor;
+ (UIColor *)navigationTitleColor;
+ (UIColor *)navigationTitleInactiveColor;
+ (UIFont *)navigationTitleFont;

+ (UIFont *)tabItemFont;

+ (UIFont *)titleFont;
+ (UIColor *)titleColor;
+ (UIFont *)subtitleFont;
+ (UIColor *)subtitleColor;

+ (UIColor *)tableHeaderColor;

@end
