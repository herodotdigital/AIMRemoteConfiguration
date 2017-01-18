//
//  APITestCaseTests.m
//
//  Created by Maciej Gad on 14.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APITestCase.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface APITestCaseTests : APITestCase

@end

@implementation APITestCaseTests


- (void)testStubingAPI {
    //given
    NSString *url = @"http://test.com/test.json";
    [self stubURL:url withFile:@"test"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    __block NSDictionary *jsonRespone = nil;
    
    //when
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            jsonRespone = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
        }
    }];
    [task resume];
    assertWithTimeout(5, thatEventually(jsonRespone[@"key"]), is(@"value"));
}

@end
