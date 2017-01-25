//
//  RemoteConfiguration.h
//
//  Created by Maciej Gad on 14.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Configuration: NSObject

- (id)objectForKeyedSubscript:(id)key;
- (UIColor *)colorWithName:(NSString *)name;
- (UIColor *)patternWithName:(NSString *)key;
@end


@interface RemoteConfiguration : Configuration

@property (strong, readonly, nonatomic) Configuration *future;

+ (void)setup;
+ (instancetype)sharedInstace;
+ (UIColor *)colorWithName:(NSString *)name;
+ (UIColor *)patternWithName:(NSString *)key;

+ (void)useFutureConfiguration;
+ (void)update;

//UNAVAILABLE
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

