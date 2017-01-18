//
//  TestingHelper.h
//
//  Created by Kamil Ziętek on 20.10.2015.
//  Copyright © 2015 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Utilities that help writting tests.
*/
@interface TestingHelper : NSObject
/**
 Reads JSON text file and returns corresponding NSDictionary or NSArray.
 @param fileName Input JSON file name
*/
+ (id)dataFromJSONFileNamed:(NSString*)fileName;
@end
