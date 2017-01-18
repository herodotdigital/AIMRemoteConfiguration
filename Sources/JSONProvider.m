//
//  JSONProvider.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"


@concreteprotocol(JSONProvider)

+ (NSURL *)urlForFile:(NSString *)fileName {
    return nil;
}

+ (id)readJSON:(NSString *)fileName {
    NSError *error = nil;
    NSURL *url = [self urlForFile:fileName];
    if(!url) {
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (!data) {
        NSLog(@"%@", error);
        return nil;
    }
    
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!jsonObj) {
        NSAssert(jsonObj, @"%@", [error description]);
        NSLog(@"%@", error);
    }
    return jsonObj;
    
}


@end
