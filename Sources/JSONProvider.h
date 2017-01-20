//
//  JSONProvider.h
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libextobjc/EXTConcreteProtocol.h>


@protocol JSONProvider <NSObject>

@concrete
+ (NSURL *)urlForFile:(NSString *)fileName;
+ (id)readJSON:(NSString *)fileName;

@end


@protocol JSONWriter <NSObject>

+ (BOOL)writeJSON:(id)json toFile:(NSString *)fileName;
+ (BOOL)removeJSON:(NSString *)fileName;

@end
