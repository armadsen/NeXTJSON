//
//  ORSJSONSerialization.m
//  NeXTJSON
//
//  Created by Andrew Madsen on 11/28/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

#import "ORSJSONSerialization.h"
#import "cJSON.h"

@implementation ORSJSONSerialization

+ (id)JSONObjectWithData:(NSData *)data options:(ORSJSONReadingOptions)options
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    cJSON *root = cJSON_Parse([string cStringUsingEncoding:NSUTF8StringEncoding]);
    
    [string release];
    if (!root) { return nil; }
    
    return [self foundationObjectFromCJSONObject:root];
}

+ (NSData *)dataWithJSONObject:(id)obj options:(ORSJSONWritingOptions)options
{
    return [NSData data];
}

#pragma mark - Private

#pragma mark Parsing

+ (id)foundationObjectFromCJSONObject:(cJSON *)cJSON
{
    switch (cJSON->type) {
        case cJSON_False:
            return [NSNumber numberWithBool:NO];
            break;
        case cJSON_True:
            return [NSNumber numberWithBool:YES];
            break;
        case cJSON_NULL:
            return [NSNull null];
            break;
        case cJSON_Number:
            return [self numberFromCJSONNumber:cJSON];
            break;
        case cJSON_String:
            return [self stringFromCJSONString:cJSON];
            break;
        case cJSON_Array:
            return [self arrayFromCJSONArray:cJSON];
            break;
        case cJSON_Object:
            return [self dictionaryFromCJSONObject:cJSON];
        default:
            return nil;
            break;
    }
}

+ (NSNumber *)numberFromCJSONNumber:(cJSON *)cJSONObj
{
    if (cJSONObj->type != cJSON_Number) { return nil; }
    if (!cJSONObj->valuedouble) {
        return [NSNumber numberWithDouble:cJSONObj->valuedouble];
    } else {
        return [NSNumber numberWithInt:cJSONObj->valueint];
    }
}

+ (NSString *)stringFromCJSONString:(cJSON *)cJSONObj
{
    if (cJSONObj->type != cJSON_String) { return nil; }
    if (!cJSONObj->valuestring) { return nil; }
    
    return [[NSString alloc] initWithCString:cJSONObj->valuestring encoding:NSUTF8StringEncoding];
}

+ (NSArray *)arrayFromCJSONArray:(cJSON *)cJSONObj
{
    if (cJSONObj->type != cJSON_Array) { return nil; }
    
    NSMutableArray *result = [NSMutableArray array];
    cJSON *obj;
    cJSON_ArrayForEach(obj, cJSONObj) {
        id foundationObject = [self foundationObjectFromCJSONObject:obj];
        if (foundationObject) { [result addObject:foundationObject]; }
    }
    
    return [[result copy] autorelease];
}

+ (NSDictionary *)dictionaryFromCJSONObject:(cJSON *)cJSONObj
{
    if (cJSONObj->type != cJSON_Object) { return nil; }
    if (cJSONObj->string != NULL) { return nil; }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    cJSON *obj;
    cJSON_ArrayForEach(obj, cJSONObj) {
        NSString *key = [[NSString alloc] initWithCString:obj->string encoding:NSUTF8StringEncoding];
        id value = [self foundationObjectFromCJSONObject:obj];
        if (key && value) { [result setObject:value forKey:key]; }
        [key release];
    }
    
    return [[result copy] autorelease];
}

@end
