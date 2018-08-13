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
#import "RACReturnSignal.h"
//#import "RACEXTScope.h"

@interface ViewController () <testProtocol>

@property (nonatomic, strong) RACCommand *command;
@property (nonatomic, strong) UIView *redV;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;

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
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//
//            // 3.发送信号
//            [subscriber sendNext:@"1"];
//
//            // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
//            [subscriber sendCompleted];
//
//        return nil;
//    }];

    // 2.订阅信号
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"接收到的数据%@",x);
//    }];


    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
//    // 1.创建信号
//    RACSubject *subject = [RACSubject subject];
//
//    // 2.订阅信号
//    [subject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅者1订阅信号%@",x);
//    }];
//    [subject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅者2订阅信号%@",x);
//    }];
//    // 3.发送信号
//    [subject sendNext:@"2"];
    
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACReplaySubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // 1.创建信号
//    RACReplaySubject *replaySubject = [RACReplaySubject subject];
//
//    // 2.发送信号
//    [replaySubject sendNext:@"1"];
//    [replaySubject sendNext:@"2"];
//
//    // 3.订阅信号
//    [replaySubject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅1---%@",x);
//    }];
//
//    [replaySubject subscribeNext:^(id  _Nullable x) {
//        NSLog(@"订阅2---%@",x);
//    }];
//
//    RACTuple *tuple = RACTuplePack(@"name",@"xiaoming");
//
//    // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
//    // key = @"name" value = @"xiaoming"
//    RACTupleUnpack(NSString *key,NSString *value) = tuple;
//    NSLog(@"key=%@,value=%@",key,value);
//
//    // 上面代码是下面代码的简写
//    RACTuple *tuple2 = [RACTuple tupleWithObjectsFromArray:@[@1,@2]];
//    NSLog(@"%@",tuple2[0]);
    
//    [self racPrintArray];
//    [self racPrintDictionary];
//    [self dictionaryToModel];
//    [self commandTest4];
//    [self multicastConnectionTest];
    
    [self bindTest];
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
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence arr.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,arr.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    NSArray *arr = @[@"1",@"2",@"3",@"4"];
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

#pragma mark - 遍历字典
- (void)racPrintDictionary {
    
    // 遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"username": @"zhangsan", @"password": @"123"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        NSLog(@"key = %@, val = %@",x[0],x[1]);
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
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
    [dictArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {

        Person *p = [Person personWithDict:obj];
        [modelArr addObject:p];
    }];
    
    
    // rac 普通用法
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {

        Person *p = [Person personWithDict:x];
        [modelArr addObject:p];

        if (dictArr.count == modelArr.count) {
            dispatch_semaphore_signal(semaphore);
        }
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"%@",modelArr);
    
    // rac 高级用法
    
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    modelArr = [[[dictArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [Person personWithDict:value];
    }] array] copy];
    NSLog(@"%@",modelArr);
}

- (void)commandTest1 {
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    // 六、使用场景,监听按钮点击，网络请求
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        // 1.创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *outPut = [NSString stringWithFormat:@"---%@---",input];
            [subscriber sendNext:outPut];
            [subscriber sendCompleted]; // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            
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
    // 订阅RACCommand中的信号
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
 // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
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
    
   // 监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
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
    
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        NSLog(@"发送请求");
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1--%@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2--%@",x);
    }];
    // 运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求
    
    // RACMulticastConnection:解决重复请求问题
    RACMulticastConnection *connection = [signal publish];
    
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1--%@",x);
    }];
   
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2--%@",x);
    }];
    // 连接,激活信号
    [connection connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tt {
    UIView *redV = [[UIView alloc] init];
    
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[redV rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
    
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
    
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

- (void)rr {
    
    RAC(self.label,text) = self.textField.rac_textSignal;
    
    // 上面的代码等于下边
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        self.label.text = x;
    }];
    
    
    [RACObserve(self.view, backgroundColor) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    // 上面的代码等于下边
    [[self.view rac_valuesAndChangesForKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)bindTest {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"hello"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    
    RACSignal *bindSignal = [signal bind:^RACSignalBindBlock _Nonnull{
       
        return ^RACSignal *(id value,BOOL *stop) {
            
            NSLog(@"%@",value);
            NSString *output = [NSString stringWithFormat:@"output: %@",value];
            return [RACReturnSignal return:output];
        };
    }];
    [bindSignal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"---%@",x);
    }];
    
}


@end
