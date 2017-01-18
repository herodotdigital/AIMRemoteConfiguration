//
//  TestingHelper.m
//
//  Created by Kamil Ziętek on 20.10.2015.
//  Copyright © 2015 All in Mobile. All rights reserved.
//

#import "TestingHelper.h"


@implementation TestingHelper

+ (id)dataFromJSONFileNamed:(NSString *)fileName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"json"];

    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSAssert(data != nil, @"can't read data from %@.json", fileName);
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return jsonObj;
}

@end
