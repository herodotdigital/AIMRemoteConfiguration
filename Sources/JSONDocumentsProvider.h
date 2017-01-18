//
//  JSONDocumentsProvider.h
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONProvider.h"

@interface JSONDocumentsProvider : NSObject <JSONProvider, JSONWriter>

+ (NSURL *)applicationDocumentsDirectory;

@end
