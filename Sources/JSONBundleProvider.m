//
//  NSDictionary+fromJSON.m
//
//  Created by Maciej Gad on 04.08.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "JSONBundleProvider.h"

@implementation JSONBundleProvider

+ (NSURL *)urlForFile:(NSString *)fileName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [bundle URLForResource:fileName withExtension:@"json"];
}


@end

@implementation NSDictionary (fromJSON)

+ (instancetype)fromJSON:(NSString *)fileName {
    id jsonObj = [JSONBundleProvider readJSON:fileName];
    if (![jsonObj isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return jsonObj;
}

@end


@implementation NSArray (fromJSON)

+ (instancetype)fromJSON:(NSString *)fileName {
    id jsonObj = [JSONBundleProvider readJSON:fileName];
    if (![jsonObj isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return jsonObj;
}

@end
