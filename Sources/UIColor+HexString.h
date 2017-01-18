//
//  UIColor+HexString.h
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
@end

@interface NSString (HexString)
- (BOOL)isHexadecimal;
- (UIColor *)color;
@end
