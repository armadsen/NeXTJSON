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
	NSURL *testFilesFolderURL = [bundle URLForResource:@"tests" withExtension:nil];
	NSArray *testFiles = [bundle URLsForResourcesWithExtension:@"json" subdirectory:[testFilesFolderURL lastPathComponent]];
	for (NSURL *url in testFiles) {
		[self _testParsingFileAtURL:url];
	}
}

- (void)_testParsingFileAtURL:(NSURL *)url
{
	NSData *testData = [NSData dataWithContentsOfURL:url];
	XCTAssertNotNil(testData, @"Unable to read data from %@", url);
	
	NSError *error = nil;
	id controlObject = [NSJSONSerialization JSONObjectWithData:testData options:0 error:&error];
	XCTAssertNotNil(controlObject, @"Unable to parse data from %@ with NSJSONSerialization: %@", url, error);
	
	id testObject = [ORSJSONSerialization JSONObjectWithData:testData options:0];
	XCTAssertNotNil(controlObject);
	
	XCTAssertEqualObjects(controlObject, testObject, @"Test object not equal to control object for %@", url);
}

@end
