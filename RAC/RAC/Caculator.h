//
//  Caculator.h
//  RAC
//
//  Created by yan on 2018/8/10.
//  Copyright © 2018年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

// caculator.h
@interface Caculator : NSObject

@property (nonatomic, assign) CGFloat result;

- (instancetype)caculator:(CGFloat(^)(int x))block;

@end
