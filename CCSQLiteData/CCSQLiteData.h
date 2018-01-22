//
//  CCSQLiteData.h
//  CCSQLiteDemo
//
//  Created by dengyouhua on 22/01/2018.
//  Copyright © 2018 CC | ccworld1000@gmail.com. All rights reserved.
//  https://github.com/ccworld1000/CCSQLite
//

#import <Foundation/Foundation.h>

@interface CCSQLiteData : NSObject

+ (void) writeDataList;
+ (NSArray *) readDataList;

// for res
+ (NSArray *) readDefaultDataList;

@end

