//
//  ConfigurableApiRequest.h
//  RemoteConfiguration
//
//  Created by Maciej Gad on 18.01.2017.
//  Copyright © 2017 Maciej Gad. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigurableApiRequest : NSObject

/**
 block called on success response from server with data as `responseObject`
 */
@property (nonatomic, copy) void (^success)(id responseObject);
/**
 block called on failure with error as `error`
 */
@property (nonatomic, copy) void (^failure)(NSError *error);

@property (readonly, strong, nonatomic) NSString *path;

/**
 get
 */
- (void)get;

- (instancetype)initWithPath:(NSString *)string NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


@end
