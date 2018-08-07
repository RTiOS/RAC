//
//  DelegateTestController.m
//  RAC
//
//  Created by yan on 2018/8/7.
//  Copyright © 2018年 yan. All rights reserved.
//

#import "DelegateTestController.h"

@interface DelegateTestController ()

@end

@implementation DelegateTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(50, 150, 200, 100);
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"normal delegate test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame = CGRectMake(50, 350, 200, 100);
    button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button2 setBackgroundColor:[UIColor redColor]];
    [button2 setTitle:@"rac delegate test" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(racBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)btnClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(buttonDidClick:)]) {
        [_delegate buttonDidClick:btn];
    }
}

- (void)racBtnDidClick:(UIButton *)btn {
    [_subject sendNext:btn];
}

- (RACSubject *)subject {
    if (nil == _subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
