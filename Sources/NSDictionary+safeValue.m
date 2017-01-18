//
//  NSDictionary+safeValue.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "NSDictionary+safeValue.h"
#import "NSArray+safe.h"

@implementation NSDictionary (safeValue)

- (id)safeValueForKey:(NSString *)key {
    if ([key length] == 0) {
        return nil;
    }
    if (![key containsString:@"."]) {
        return self[key];
    }
    NSMutableArray *keyComponents = [[key componentsSeparatedByString:@"."] mutableCopy];
    return [self safeValueForKeyComponents:keyComponents];
}

- (id)safeValueForKeyComponents:(NSMutableArray *)keyComponents {
    if ([keyComponents count] == 0) {
        return nil;
    }
    NSString *currentKey = keyComponents[0];
    id currentObject = nil;
    if ([currentKey containsString:@"["]) {
        currentObject = [self valueFromArrayForKey:currentKey];
    } else {
        currentObject = self[currentKey];
    }
    
    if ([keyComponents count] == 1) {
        return currentObject;
    }

    if ([currentObject isKindOfClass:[NSDictionary class]]) {
        [keyComponents removeObjectAtIndex:0];
        NSDictionary *currentDictionary = currentObject;
        return [currentDictionary safeValueForKeyComponents:keyComponents];
    }
    return nil;
}

- (id)valueFromArrayForKey:(NSString *)key {
    NSMutableArray *keyComponents = [[key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]] mutableCopy];
    
    if ([keyComponents count] == 0) {
        return nil;
    }
    
    NSString *currentKey = keyComponents[0];
    [keyComponents removeObjectAtIndex:0];
    
    NSArray *currentArray = self[currentKey];
    
    for (NSString *value in [keyComponents copy]) {
        if ([value length] == 0) {
            continue;
        }
        NSString *stringNr = [value stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        if ([stringNr length] == 0) {
            return nil;
        }
        
        if (![currentArray isKindOfClass:[NSArray class]]) {
            return nil;
        }
        currentArray = [currentArray safeGet:[stringNr integerValue]];
    }
    
    return currentArray;
}

@end
