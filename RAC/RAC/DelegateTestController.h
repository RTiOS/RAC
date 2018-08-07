//
//  DelegateTestController.h
//  RAC
//
//  Created by yan on 2018/8/7.
//  Copyright © 2018年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

@protocol testProtocol <NSObject>

- (void)buttonDidClick:(id)btn;

@end

@interface DelegateTestController : UIViewController

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) RACSubject *subject;

@end
