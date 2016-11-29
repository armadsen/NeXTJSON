//
//  NeXTJSONTests.m
//  NeXTJSONTests
//
//  Created by Andrew Madsen on 11/28/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <NeXTJSON/NeXTJSON.h>

@interface NeXTJSONTests : XCTestCase

@end

@implementation NeXTJSONTests

- (void)test1
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *testFileURL = [bundle URLForResource:@"test1" withExtension:nil];
    
    NSData *testData = [NSData dataWithContentsOfURL:testFileURL];
    XCTAssertNotNil(testData);
    
    id controlObject = [NSJSONSerialization JSONObjectWithData:testData options:0 error:NULL];
    XCTAssertNotNil(controlObject);
    
    id testObject = [ORSJSONSerialization JSONObjectWithData:testData options:0];
    XCTAssertNotNil(controlObject);
    
    XCTAssertEqualObjects(controlObject, testObject, @"Test object not equal to control object");
    
    NSLog(@"%@", testFileURL);
}

@end
