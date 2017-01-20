//
//  UIColor+list.m
//  RemoteConfiguration
//
//  Created by Maciej Gad on 19.01.2017.
//  Copyright © 2017 Maciej Gad. All rights reserved.
//

#import "UIColor+list.h"
#import "RemoteConfiguration.h"

#define colorName ([NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"Color" withString:@""])

@implementation UIColor (list)

+ (UIColor *)backgroundColor {
    return [RemoteConfiguration colorWithName:colorName]?: [UIColor purpleColor];
}

+ (UIColor *)textColor {
    return [RemoteConfiguration colorWithName:colorName]?: [UIColor blackColor];
}

@end
