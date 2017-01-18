//
//  APITestCase.m
//
//  Created by Maciej Gad on 14.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import "APITestCase.h"
#import "TestingHelper.h"
#import "OHHTTPStubs.h"
#import "OHHTTPStubsResponse+JSON.h"
#import "OHPathHelpers.h"


@implementation APITestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];
    [super tearDown];
}

- (void)stubURL:(NSString *)url withFile:(NSString *)filename {
    NSString *stubedUrl = [url stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *absoluteString = request.URL.absoluteString;
        return [absoluteString isEqualToString:url] || [absoluteString isEqualToString:stubedUrl];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        id ApiResponse = [TestingHelper dataFromJSONFileNamed:filename];
        return [OHHTTPStubsResponse responseWithJSONObject:ApiResponse statusCode:200 headers:nil];
    }];
}


- (void)stubURL:(NSString *)url withPNG:(NSString *)filename {
    NSString *stubedUrl = [url stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *absoluteString = request.URL.absoluteString;
        return [absoluteString isEqualToString:url] || [absoluteString isEqualToString:stubedUrl];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(filename, self.class)
                                             statusCode:200
                                                   headers:@{@"Content-Type":@"image/png"}];
    }];

}


@end
