//
//  JSONDocumentsBoundleProvider.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "JSONDocumentsBoundleProvider.h"
#import "JSONDocumentsProvider.h"
#import "JSONBundleProvider.h"


@implementation JSONDocumentsBoundleProvider

+ (id)readJSON:(NSString *)fileName {
    return [self readJSON:fileName class:Nil];
}
+ (id)readJSON:(NSString *)fileName class:(Class)class{
    id response = [JSONDocumentsProvider readJSON:fileName];
    
    if (class != Nil) {
        if ([response isKindOfClass:class]) {
            return response;
        }
    } else {
        if (response) {
            return response;
        }
    }
    
    response = [JSONBundleProvider readJSON:fileName];

    if (class != nil) {
        if ([response isKindOfClass:class]) {
            return response;
        }
        return nil;
    }
    return response;
}

+ (NSDictionary *)dictionaryFrom:(NSString *)fileName {
    return (NSDictionary *)[self readJSON:fileName class:[NSDictionary class]];
}

+ (NSArray *)arrayFrom:(NSString *)fileName {
    return (NSArray *)[self readJSON:fileName class:[NSArray class]];
}

+ (BOOL)writeJSON:(id)json toFile:(NSString *)fileName {
    return [JSONDocumentsProvider writeJSON:json toFile:fileName];
}

+ (BOOL)removeJSON:(NSString *)fileName {
    return [JSONDocumentsProvider removeJSON:fileName];
}

@end
