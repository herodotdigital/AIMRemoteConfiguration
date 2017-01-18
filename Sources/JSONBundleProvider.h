//
//  NSDictionary+fromJSON.h
//
//  Created by Maciej Gad on 04.08.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@interface JSONBundleProvider : NSObject <JSONProvider>
@end

@interface NSDictionary (fromJSON)

+ (instancetype)fromJSON:(NSString *)fileName;

@end

@interface NSArray (fromJSON)

+ (instancetype)fromJSON:(NSString *)fileName;

@end
