//
//  NSArray+safe.m
//  SaveDrivePath
//
//  Created by Maciej Gad on 29.05.2015.
//  Copyright (c) 2015 Maciej Gad. All rights reserved.
//

#import "NSArray+safe.h"

@implementation NSArray (safe)

- (id)safeGet:(NSInteger)index {
    if (index < 0) {
        return nil;
    }
    if (self.count > index) {
        return self[index];
    }
    return nil;
}

- (NSArray *)silceFirst:(NSInteger)n {
     return [self subarrayWithRange:NSMakeRange(0, MIN(n, self.count))];
}

@end

@implementation NSMutableArray (safe)

- (void)safeAdd:(id)object {
    if (object != nil) {
        [self addObject:object];
    }
}


@end

@implementation NSMutableSet (safe)

- (void)safeAdd:(id)object {
    if (object != nil) {
        [self addObject:object];
    }
}

@end