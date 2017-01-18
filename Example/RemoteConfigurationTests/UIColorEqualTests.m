//
//  UIColorEqualTests.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "UIColor+equal.h"
#import "UIColor+HexString.h"

@interface UIColorEqualTests : XCTestCase

@end

@implementation UIColorEqualTests


- (void)testWhite {
    //given
    UIColor *sut = [UIColor colorWithHexString:@"#FFFFFF"];
    UIColor *color = [UIColor whiteColor];
    
    //when & then
    assertThatBool([sut isEqualToColor:color], isTrue());
}

- (void)testBlack3letters {
    //given
    UIColor *sut = [UIColor colorWithHexString:@"#000"];
    UIColor *color = [UIColor blackColor];
    
    //when & then
    assertThatBool([sut isEqualToColor:color], isTrue());
}

- (void)testString {
    //given
    UIColor *sut = [@"0000A0" color];
    UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:0.6275 alpha:1.0];
    
    //when & then
    assertThatBool([sut isEqualToColor:color], isTrue());
}

- (void)testColorWithAlpha {
    //given
    UIColor *sut = [UIColor colorWithHexString:@"#7f24C42F"];
    UIColor *color = [UIColor colorWithRed:0.14118 green:0.76863 blue:0.18431 alpha:0.5];
    
    //when & then
    assertThatBool([sut isEqualToColor:color], isTrue());
}

- (void)testColorWithAlpha4letters  {
    //given
    UIColor *sut = [UIColor colorWithHexString:@"#7b24"];
    UIColor *color = [UIColor colorWithRed:0.73333 green:0.13333 blue:0.26666 alpha:0.46667];
    
    //when & then
    assertThatBool([sut isEqualToColor:color], isTrue());
}

@end
