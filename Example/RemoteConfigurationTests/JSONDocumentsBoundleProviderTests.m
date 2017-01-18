//
//  JSONDocumentsBoundleProviderTests.m
//
//  Created by Maciej Gad on 15.09.2016.
//  Copyright © 2016 All in Mobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "JSONDocumentsBoundleProvider.h"
#import "JSONDocumentsProvider.h"
#import "JSONBundleProvider.h"

static NSString *const JsonTestFileName = @"theme";

@interface JSONDocumentsBoundleProviderTests : XCTestCase

@end

@implementation JSONDocumentsBoundleProviderTests

- (void)setUp {
    [super setUp];
    [JSONDocumentsProvider removeJSON:JsonTestFileName];
}

- (void)tearDown {
    [JSONDocumentsProvider removeJSON:JsonTestFileName];
    [super tearDown];
}

- (void)testReadingFromBundle {
    //given
    NSDictionary *boundleData = [NSDictionary fromJSON:JsonTestFileName];
    
    //when
    NSDictionary *result = [JSONDocumentsBoundleProvider readJSON:JsonTestFileName];
    
    //then
    assertThat(result, is(boundleData));
}

- (void)testReadingFromDocuments {
    //given
    NSDictionary *boundleData = [NSDictionary fromJSON:JsonTestFileName];
    NSDictionary *testData = @{@"key":@"value"};
    
    //when
    assertThatBool([JSONDocumentsProvider writeJSON:testData toFile:JsonTestFileName], isTrue());
    NSDictionary *result = [JSONDocumentsBoundleProvider readJSON:JsonTestFileName];
    
    //then
    assertThat(result, is(testData));
    assertThat(result, isNot(boundleData));
}

- (void)testReadingFromBundleAndThenFromDocuments {
    //given
    NSDictionary *boundleData = [NSDictionary fromJSON:JsonTestFileName];
    NSDictionary *testData = @{@"key":@"value"};
    
    //when
    NSDictionary *resultBoundle = [JSONDocumentsBoundleProvider readJSON:JsonTestFileName];
    assertThatBool([JSONDocumentsBoundleProvider writeJSON:testData toFile:JsonTestFileName], isTrue());
    NSDictionary *resultDocuments = [JSONDocumentsBoundleProvider readJSON:JsonTestFileName];
    assertThatBool([JSONDocumentsBoundleProvider removeJSON:JsonTestFileName], isTrue());
    NSDictionary *resultBoundle2 = [JSONDocumentsBoundleProvider readJSON:JsonTestFileName];
    
    //then
    assertThat(resultBoundle, is(boundleData));
    assertThat(resultDocuments, is(testData));
    assertThat(resultBoundle2, is(boundleData));

}

- (void)testReadingDictionary {
    //given
    NSDictionary *boundleData = [NSDictionary fromJSON:JsonTestFileName];
    NSArray *testData = @[@"value"];
    
    //when
    assertThatBool([JSONDocumentsProvider writeJSON:testData toFile:JsonTestFileName], isTrue());
    NSArray *resultAray = [JSONDocumentsBoundleProvider readJSON:JsonTestFileName];
    NSDictionary *result = [JSONDocumentsBoundleProvider dictionaryFrom:JsonTestFileName];
    
    //then
    assertThat(result, is(boundleData));
    assertThat(resultAray, is(testData));
}


@end
