//
//  JSONDocumentsProvider.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "JSONDocumentsProvider.h"

@implementation JSONDocumentsProvider

+ (BOOL)writeJSON:(id)json toFile:(NSString *)fileName {
    
    NSError *error = nil;
    NSURL *url = [self urlForFile:fileName];
    
    @try {
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
        if (data == nil) {
            NSLog(@"%@", error);
            return NO;
        }
        BOOL writen = [data writeToURL:url options:NSDataWritingAtomic error:&error];
        if (!writen) {
            NSLog(@"%@", error);
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        return NO;
    }
    return YES;
}

+ (BOOL)removeJSON:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSURL *url = [self urlForFile:fileName];
    
    if(![fileManager fileExistsAtPath:url.path]) {
        return YES;
    }
    
    BOOL removed = [fileManager removeItemAtURL:url error:&error];
    if (!removed) {
        NSLog(@"%@", error);
    }
    return removed;
}


+ (NSURL *)urlForFile:(NSString *)fileName {
    return [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName] URLByAppendingPathExtension:@"json"];
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
