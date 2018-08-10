//
//  Person.m
//  RAC
//
//  Created by yan on 2018/8/7.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "Person.h"

@implementation Person


+ (instancetype)personWithDict:(NSDictionary *)dict {
   
    Person *p = [[self alloc] init];
    [p setValuesForKeysWithDictionary:dict];
    return p;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end

