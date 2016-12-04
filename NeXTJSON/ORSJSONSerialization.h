//
//  ORSJSONSerialization.h
//  NeXTJSON
//
//  Created by Andrew Madsen on 11/28/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ORSJSONReadingMutableContainers = (1 << 0),
    ORSJSONReadingMutableLeaves = (1 << 1),
    ORSJSONReadingAllowFragments = (1 << 2)
} ORSJSONReadingOptions;

typedef enum {
    ORSJSONWritingPrettyPrinted = (1 << 0)
} ORSJSONWritingOptions;

@interface ORSJSONSerialization : NSObject

+ (id)JSONObjectWithData:(NSData *)data options:(ORSJSONReadingOptions)options;
+ (NSData *)dataWithJSONObject:(id)obj options:(ORSJSONWritingOptions)options;

@end
