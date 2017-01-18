//
//  APITestCase.h
//
//  Created by Maciej Gad on 14.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//
#import <XCTest/XCTest.h>

@interface APITestCase : XCTestCase

- (void)stubURL:(NSString *)url withFile:(NSString *)filename;
- (void)stubURL:(NSString *)url withPNG:(NSString *)filename;
@end
