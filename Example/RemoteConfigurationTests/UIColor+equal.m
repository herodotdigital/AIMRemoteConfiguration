//
//  UIColor+equal.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "UIColor+equal.h"

static inline BOOL RGBequal(CGFloat a, CGFloat b) {
    return fabs(a - b) < 0.002; //1.0/255 * 0.5
}

@implementation UIColor (equal)



- (BOOL)isEqualToColor:(UIColor *)otherColor {
    if (self == otherColor) {
        return YES;
    }
    
    CGFloat r1, g1, b1, a1;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    
    CGFloat r2, g2, b2, a2;
    [otherColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    if (!RGBequal(r1, r2)) {
        return NO;
    }
    
    if (!RGBequal(g1, g2)) {
        return NO;
    }
    
    if (!RGBequal(b1, b2)) {
        return NO;
    }
    
    if (!RGBequal(a1, a2)) {
        return NO;
    }
    
    return YES;
}

@end
