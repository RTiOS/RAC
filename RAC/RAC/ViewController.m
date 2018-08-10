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
#import "Caculator.h"

@interface ViewController () <testProtocol>

@property (nonatomic, strong) RACCommand *command;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//main.m
    
//    Caculator *caculator = [[Caculator alloc] init];
//    CGFloat result = [[caculator caculator:^CGFloat(int x) {
//        x = x + 10;
//        x = x * 2;
//        x = x / 3;
//        return x;
//    }] result];
//
//    NSLog(@"result = %.2f", result);
    
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

            // 3.发送信号
            [subscriber sendNext:@"1"];
        
            // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
            [subscriber sendCompleted];
      
        return nil;
    }];

    // 2.订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到的数据%@",x);
    }];


    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];

    // 2.订阅信号
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1订阅信号%@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2订阅信号%@",x);
    }];
    // 3.发送信号
    [subject sendNext:@"2"];
    
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
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
//    [self commandTest4];
//    [self multicastConnectionTest];
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
    
    RACSignal *signal = [command execute:@"hello"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"--收到%@",x);
    }];
}

- (void)commandTest2 {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *output = [NSString stringWithFormat:@"---%@---",input];
            [subscriber sendNext:output];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"--收到%@",x);
        }];
    }];
    [command execute:@"hello"]; // 先订阅才可以
}


- (void)commandTest3 {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {

        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

            NSString *output = [NSString stringWithFormat:@"---%@---",input];
            [subscriber sendNext:output];
            [subscriber sendCompleted];

            return nil;
        }];
    }];

    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到%@",x);
    }];

    [command execute:@"hello"];
    
}

- (void)commandTest4 {
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *output = [NSString stringWithFormat:@"---%@---",input];
            [subscriber sendNext:output];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
   
    [[command.executing skip:1] subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"~~%@",x);
        if ([x boolValue]) {
            NSLog(@"执行中");
        }else {
            NSLog(@"完成");
        }
    }];
    
     [command execute:@"hello"];
}

- (void)multicastConnectionTest {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        NSLog(@"发送请求");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"1--%@",x);
//    }];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"2--%@",x);
//    }];
    
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1--%@",x);
    }];
   
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2--%@",x);
    }];
    
    [connection connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
