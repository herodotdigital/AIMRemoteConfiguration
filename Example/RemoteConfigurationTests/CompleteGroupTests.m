//
//  CompleteGroupTests.m
//
//  Created by Maciej Gad on 04.09.2015.
//  Copyright (c) 2015 All in Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CompleteGroup.h"

@interface CompleteGroupTests : XCTestCase
@property (strong, nonatomic) CompleteGroup *group;
@end

@implementation CompleteGroupTests

- (void)setUp {
    [super setUp];
    self.group = [CompleteGroup new];
}

- (void)tearDown {
    self.group = nil;
    [super tearDown];
}

- (void)testSynchronousBlock {
    //given
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynch"];
    __block BOOL blockWasRun = NO;
    __block BOOL secondBlockWasRun = NO;
    
    __weak __typeof(self) weakSelf = self;
    self.group.complete = ^{
        __strong __typeof(weakSelf)self = weakSelf;
        XCTAssertTrue(blockWasRun, @"Completion block should be run as last element");
        XCTAssertTrue(secondBlockWasRun, @"Completion block should be run as last element");
        [expectation fulfill];
    };
    
    [self.group addBlock:^(Group *group){
        blockWasRun = YES;
        [group leave];
    }];
    
    [self.group addBlock:^(Group *group){
        secondBlockWasRun = YES;
        [group leave];
    }];

    
    [self.group run];

    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testAsynchronusBlock {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynch"];
    __block NSNumber *blockWasRun = @NO;
    
    __weak __typeof(self) weakSelf = self;
    
    self.group.complete = ^{
        __strong __typeof(weakSelf)self = weakSelf;
        XCTAssertTrue([blockWasRun boolValue], @"Completion block should be run as last element");
        [expectation fulfill];
    };
    
    [self.group addBlock:^(Group *group) {
       dispatch_async(dispatch_queue_create(0, 0), ^{
           sleep(0.5);
           blockWasRun = @YES;
           [group leave];
       });
    }];
    
    [self.group run];
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testIfGroupIsRunning {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynch"];
    self.group.complete = ^{
        [expectation fulfill];
    };
    
    [self.group addBlock:^(Group *group) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            sleep(0.5);
            [group leave];
        });
    }];
    [self.group run];
    XCTAssertTrue(self.group.isRunning);
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        XCTAssertFalse(self.group.isRunning);
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testIfGroupIsFinished {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynch"];
    __weak __typeof(self) weakSelf = self;
    
    self.group.complete = ^{
        __strong __typeof(weakSelf)self = weakSelf;
        XCTAssertFalse(self.group.isFinished);
        [expectation fulfill];
    };
    
    [self.group addBlock:^(Group *group) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            sleep(0.5);
            [group leave];
        });
    }];
    [self.group run];
    XCTAssertFalse(self.group.isFinished);
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        XCTAssertTrue(self.group.isFinished);
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void)testSerialQueue {
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynch"];
    __weak __typeof(self) weakSelf = self;
    __block BOOL firstStep = NO;
    __block BOOL secoundStep = NO;
    self.group.serialQueue = YES;
    self.group.complete = ^{
        __strong __typeof(weakSelf)self = weakSelf;
        XCTAssertTrue(firstStep);
        XCTAssertTrue(secoundStep);
        [expectation fulfill];
    };
    [self.group addBlock:^(Group *group) {
        dispatch_async(dispatch_queue_create(0, 0), ^{
            sleep(1.0);
            firstStep = YES;
            [group leave];
        });
    }];
    [self.group addBlock:^(Group *group) {
        __strong __typeof(weakSelf)self = weakSelf;
        XCTAssertTrue(firstStep);
        dispatch_async(dispatch_queue_create(0, 0), ^{
            sleep(0.5);
            secoundStep = YES;
            [group leave];
        });
    }];
    [self.group run];
    
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

@end
