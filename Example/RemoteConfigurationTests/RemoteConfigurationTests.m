//
//  RemoteConfigurationTests.m
//
//  Created by Maciej Gad on 14.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APITestCase.h"
#import "RemoteConfiguration.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#import "UIColor+equal.h"
#import "UIColor+HexString.h"
#import "JSONDocumentsProvider.h"
#import "NSDictionary+safeValue.h"
#import "TestingHelper.h"

static NSString * const kThemeFileName = @"theme";
static NSString * const kThemeUrl = @"http://test.com/config.json";

@interface NSFileManager (Test)
+(BOOL)removeFile:(NSString *)path;
@end

@implementation NSFileManager (Test)

+(BOOL)removeFile:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSURL *base = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *url = [base URLByAppendingPathComponent:path];
    
    if(![fileManager fileExistsAtPath:url.path]) {
        return YES;
    }
    
    BOOL removed = [fileManager removeItemAtURL:url error:&error];
    if (!removed) {
        NSLog(@"%@", error);
    }
    return removed;
}

@end

@interface RemoteConfiguration (tests)
- (instancetype)initWithLocalName:(NSString *)fileName remote:(NSString *)url;
@end

@interface RemoteConfigurationTests : APITestCase
@property (strong, nonatomic) RemoteConfiguration *sut;
@end

@implementation RemoteConfigurationTests

- (void)setUp {
    [super setUp];
    [JSONDocumentsProvider removeJSON:kThemeFileName];
    [self stubURL:kThemeUrl withFile:@"themeTest"];
    [self stubURL:@"http://test.com/images/pattern.png" withPNG:@"test.png"];
    self.sut = [[RemoteConfiguration alloc] initWithLocalName:kThemeFileName remote:kThemeUrl];
}

- (void)tearDown {
    self.sut = nil;
    [JSONDocumentsProvider removeJSON:kThemeFileName];
    [NSFileManager removeFile:@"pattern_background.jpg"];
    [super tearDown];
}


- (void)testLoadingRawDataFromLocal {
    //given
    NSString *key = @"colors.background";
    NSString *value = @"#FAAE35";
    
    //when
    NSString *testValue = self.sut[key];
    
    //then
    assertThat(testValue, is(value));
}

- (void)testLoadingDataFromServer {
    //given
    NSString *key = @"colors.background";
    NSString *value = @"#000000";
    
    //then
    assertWithTimeout(5, thatEventually(self.sut.future[key]), is(value));
}

- (void)testLocalColor {
    //given
    NSString *key = @"background";
    UIColor *value = [@"#FAAE35" color];
    
    //when
    UIColor *color = [self.sut colorWithName:key];
    
    //then
    assertThatBool([color isEqualToColor:value], isTrue());
}

- (void)testCheckIfColorAreCached {
    //given
    NSString *key = @"background";
    
    //when
    UIColor *color1 = [self.sut colorWithName:key];
    UIColor *color2 = [self.sut colorWithName:key];
    
    //then
    assertThatBool(color1 == color2, isTrue());
}

- (void)testNotexistingColor {
    //given
    NSString *key = @"notexisting";
    
    //when
    UIColor *color = [self.sut colorWithName:key];
    
    //then
    assertThat(color, nilValue());
}

- (void)testNilColorName {
    //given
    NSString *key = nil;
    
    //when
    UIColor *color = [self.sut colorWithName:key];
    
    //then
    assertThat(color, nilValue());
}

- (void)testIfConfigIsWriteToDocuments {
    //given
    NSString *value = @"#000000";

    //then
    assertWithTimeout(10, thatEventually([self backgroundValueForDocumentConfig]), is(value));
}

- (void)testIfConfigIsReadFromDocuments {
    //given
    NSDictionary *futureData = [TestingHelper dataFromJSONFileNamed:@"themeTest"];
    NSString *value = @"#000000";
    NSString *key = @"colors.background";
    
    //when
    assertThatBool([JSONDocumentsProvider writeJSON:futureData toFile:kThemeFileName], isTrue());
    
    self.sut = [[RemoteConfiguration alloc] initWithLocalName:kThemeFileName remote:kThemeUrl];
    
    //then
    assertThat(self.sut[key], is(value));
}

- (void)testPatternFetch {
    //given
    NSURL *patternURL = [[JSONDocumentsProvider applicationDocumentsDirectory] URLByAppendingPathComponent:@"pattern_background.jpg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //then
    assertWithTimeout(10, thatEventually(@([fileManager fileExistsAtPath:patternURL.path])), isTrue());
    assertWithTimeout(10, thatEventually([self.sut.future patternWithName:@"background"]), instanceOf([UIColor class]));
}


- (NSString *)backgroundValueForDocumentConfig {
    NSDictionary *config = [JSONDocumentsProvider readJSON:kThemeFileName];
    NSString *key = @"colors.background";
    return [config safeValueForKey:key];
}

@end
