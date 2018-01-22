//
//  CCSQLiteData.m
//  CCSQLiteDemo
//
//  Created by dengyouhua on 22/01/2018.
//  Copyright © 2018 CC | ccworld1000@gmail.com. All rights reserved.
//  https://github.com/ccworld1000/CCSQLite
//

#import "CCSQLiteData.h"
#import "CCSQLite/CCSQLite.h" // if error try #import "CCSQLite/CCSQLite.h" or #import "CCSQLite.h"

#define CCSQLiteDataDB @"CCSQLiteData.sqlite"

@implementation CCSQLiteData

+ (void) writeDataList {
    NSLog(@"writeDataList");
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:CCSQLiteDataDB];
    
    CCKeyValue *kv = [CCKeyValue defaultKeyValueWithPath:path];
    kv.valueType = CCKeyValueTypeJson;
    
    NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"list" ofType:@"json"]];
    [kv setObject:data key:CCKeyValueDataKey];
}

+ (NSArray *) readDataListAtPath : (NSString *) path {
    NSArray *list = nil;
    
    if (!path) {
        return list;
    }
    
    CCKeyValue *kv = [CCKeyValue defaultKeyValueWithPath:path];
    kv.valueType = CCKeyValueTypeJson;
    
    id CCJSON =  [kv objectForKey:CCKeyValueDataKey];
    
    if ([CCJSON isKindOfClass:[NSArray class]]) {
        list = CCJSON;
    }
    
    return list;
}

+ (NSArray *) readDataList {
    NSLog(@"readDataList");
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject] stringByAppendingPathComponent:CCSQLiteDataDB];
    return [self readDataListAtPath:path];
}

+ (NSArray *) readDefaultDataList {
    NSLog(@"readDefaultDataList");
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CCSQLiteData" ofType:@"sqlite"];
    return [self readDataListAtPath:path];
}

@end
