//
//  UIImage+loadFromData.h
//  RemoteConfiguration
//
//  Created by Maciej Gad on 18.01.2017.
//  Copyright © 2017 Maciej Gad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (loadFromData)
+ (UIImage *)safeImageWithData:(NSData *)data scale:(CGFloat)scale;
+ (UIImage *)safeImageWithData:(NSData *)data;
@end
