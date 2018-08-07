//
//  Person.h
//  RAC
//
//  Created by yan on 2018/8/7.
//  Copyright © 2018年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

+ (instancetype)personWithDict:(NSDictionary *)dict;

@end
