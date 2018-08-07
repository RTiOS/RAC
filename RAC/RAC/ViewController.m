//
//  ViewController.m
//  RAC
//
//  Created by yan on 2018/8/6.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "DelegateTestController.h"
#import "Person.h"

@interface ViewController () <testProtocol>

@property (nonatomic, strong) RACCommand *command;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
//            NSLog(@"信号销毁了");
//        }];
//    }];
//
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//
//
//    RACSubject *subject = [RACSubject subject];
//
//
//    [subject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
//
//    [subject sendNext:@"2"];
    
//    RACReplaySubject *replaySubject = [RACReplaySubject subject];
//
//    [replaySubject sendNext:@"1"];
//    [replaySubject sendNext:@"2"];
//
//    [replaySubject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅1---%@",x);
//    }];
//
//    [replaySubject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅2---%@",x);
//    }];
    
//    [self racPrintArray];
//    [self racPrintDictionary];
//    [self dictionaryToModel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self delegateTest];
}

#pragma mark - delegate
- (void)delegateTest {
    
    DelegateTestController *delegateVC = [[DelegateTestController alloc] init];
    delegateVC.delegate = self;
    [self.navigationController pushViewController:delegateVC animated:YES];
    
    [delegateVC.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"rac delegate---- %@",x);
    }];
}

- (void)buttonDidClick:(id)btn {
    NSLog(@"normal delegate----- %@",btn);
}

#pragma mark - 遍历数组
- (void)racPrintArray {
    
    NSArray *arr = @[@"1",@"2",@"3",@"4"];
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 遍历字典
- (void)racPrintDictionary {
    
    NSDictionary *dict = @{@"username": @"zhangsan", @"password": @"123"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        NSLog(@"key = %@, val = %@",x[0],x[1]);
        RACTupleUnpack(NSString *key,NSString *val) = x;
        NSLog(@"key = %@, val = %@",key,val);
    }];
}

#pragma  mark - 字典转模型
- (void)dictionaryToModel {
    
    NSDictionary *p1 = @{@"name":@"zhangsan",@"age":@10};
    NSDictionary *p2 = @{@"name":@"lisi",@"age":@12};
    NSDictionary *p3 = @{@"name":@"xiaoming",@"age":@22};
    
    NSArray *dictArr = @[p1,p2,p3];
    
    // 普通写法
    NSMutableArray *modelArr = [NSMutableArray array];
//    [dictArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        Person *p = [Person personWithDict:obj];
//        [modelArr addObject:p];
//    }];
    
    
    // rac 普通用法
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//
//    [dictArr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//
//        Person *p = [Person personWithDict:x];
//        [modelArr addObject:p];
//
//        if (dictArr.count == modelArr.count) {
//            dispatch_semaphore_signal(semaphore);
//        }
//    }];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    NSLog(@"%@",modelArr);
    
    // rac 高级用法
    modelArr = [[[dictArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [Person personWithDict:value];
    }] array] copy];
    NSLog(@"%@",modelArr);
}

- (void)commandTest1 {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *outPut = [NSString stringWithFormat:@"---%@---",input];
            [subscriber sendNext:outPut];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    [command execute:@"hello"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
