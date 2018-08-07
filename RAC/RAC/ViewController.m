//
//  ViewController.m
//  RAC
//
//  Created by yan on 2018/8/6.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

//aabbb

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@"1"];
//            [subscriber sendCompleted];
//        });
//
//
//        return [RACDisposable disposableWithBlock:^{
//            NSLog(@"结束了");
//        }];
//    }];
//
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
    
    
    RACSubject *subject = [RACSubject subject];
    
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"2"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
