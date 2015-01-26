//
//  Helpers.m
//  Say It!
//
//  Created by Mike Keller on 10/2/13.
//  Copyright (c) 2013 Meek Apps. All rights reserved.
//

#import "Helpers.h"

@implementation Helpers

@end

@implementation UIColor(ColorPalette)

+ (UIColor*) sayitBlueColor {
    return [UIColor colorWithRed:75.0/255.0f
                           green:171.0f/255.0f
                            blue:177.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)sayitAccentBlueColor {
    return [UIColor colorWithRed:53.0/255.0f
                           green:146.0f/255.0f
                            blue:154.0f/255.0f
                           alpha:1.0f];
}

@end
