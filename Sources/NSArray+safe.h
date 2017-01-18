//
//  NSArray+safe.h
//  SaveDrivePath
//
//  Created by Maciej Gad on 29.05.2015.
//  Copyright (c) 2015 Maciej Gad. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 extension for `NSArray` for more safety
*/
@interface NSArray (safe)

/**
 safe get
 @param index index 
*/
- (id)safeGet:(NSInteger)index;

/**
 safe slice array
 @param n number of first n elements to slice
 */
- (NSArray *)silceFirst:(NSInteger)n;

@end

/**
extension for `NSMutableArray` for more safety
*/
@interface NSMutableArray (safe)

/**
 safe add
 @param object object 
*/
- (void)safeAdd:(id)object;

@end

/**
 extension for `NSMutableSet` for more safety
*/
@interface NSMutableSet (safe)

/**
 safe add
 @param object object 
*/
- (void)safeAdd:(id)object;

@end
