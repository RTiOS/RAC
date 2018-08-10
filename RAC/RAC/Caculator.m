//
//  Caculator.m
//  RAC
//
//  Created by yan on 2018/8/10.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "Caculator.h"

// caculator.m
@implementation Caculator

- (instancetype)caculator:(CGFloat (^)(int))block {
    _result = block(_result);
    return self;
}

@end
