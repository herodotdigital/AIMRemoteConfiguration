//
//  SafeValueTests.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDictionary+safeValue.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

@interface SafeValueTests : XCTestCase

@end

@implementation SafeValueTests

- (void)testOneLevel {
    //given
    NSString *key = @"test";
    NSString *value = @"value";
    NSDictionary *sut = @{key:value};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, is(value));
}

- (void)testTwoLevels {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"test2";
    NSString *key = [NSString stringWithFormat:@"%@.%@", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:value}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, is(value));
    assertThat([sut valueForKeyPath:key], is(value));
}

- (void)testTwoLevelsError {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"test2";
    NSString *key = [NSString stringWithFormat:@"%@.%@", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:value};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, nilValue());
    assertThat(^{[sut valueForKeyPath:key];}, throwsException(anything()));
    
}

- (void)testForArrayAsLastElement {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"array";
    NSString *key = [NSString stringWithFormat:@"%@.%@[0]", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:@[value]}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, is(value));
    assertThat([sut valueForKeyPath:key], nilValue());
}

- (void)testForArrayAsLastElementError {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"array";
    NSString *key = [NSString stringWithFormat:@"%@.%@[0]", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:value}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, nilValue());
    assertThat([sut valueForKeyPath:key], nilValue());
}

- (void)testForArrayAsLastElementNotExists {
    //given
    NSString *key1 = @"test";
    NSString *key = [NSString stringWithFormat:@"%@[1]", key1];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@[value]};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, nilValue());
    assertThat([sut valueForKeyPath:key], nilValue());
}


- (void)testForArrayAsLastElementIndexNotInt {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"array";
    NSString *key = [NSString stringWithFormat:@"%@.%@[a]", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:@[value]}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, nilValue());
    assertThat([sut valueForKeyPath:key], nilValue());
}


- (void)testForArrayInTheMiddle {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"array";
    NSString *key3 = @"test2";
    NSString *key = [NSString stringWithFormat:@"%@.%@[0].test2", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:@[@{key3:value}]}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, is(value));
    assertThat([sut valueForKeyPath:key], nilValue());
}

- (void)testFor2Arrays {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"array";
    NSString *key = [NSString stringWithFormat:@"%@.%@[0][1]", key1, key2];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:@[@[@"a",value]]}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, is(value));
    assertThat([sut valueForKeyPath:key], nilValue());
}

- (void)testFor2ArraysAndDict {
    //given
    NSString *key1 = @"test";
    NSString *key2 = @"array";
    NSString *key3 = @"test2";
    NSString *key = [NSString stringWithFormat:@"%@.%@[0][1].%@", key1, key2, key3];
    NSString *value = @"value";
    NSDictionary *sut = @{key1:@{key2:@[@[@"a",@{key3:value}]]}};
    
    //when
    NSString *response = [sut safeValueForKey:key];
    
    //then
    assertThat(response, is(value));
    assertThat([sut valueForKeyPath:key], nilValue());
}



@end
