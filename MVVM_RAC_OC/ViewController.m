//
//  ViewController.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/29.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "ViewController.h"
#import <RACSignal.h>
#import <RACSubscriber.h>
#import <RACDisposable.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1、创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //send signal
        NSLog(@"signal content:1");

        [subscriber sendNext:@"send"];
        NSLog(@"signal content:2");

        [subscriber sendCompleted];
        NSLog(@"signal content:3");

        return nil;
    }];
    //2、订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        //收到信号
        NSLog(@"signal content:4");

        NSLog(@"signal content:%@",x);
    }];
    
    NSLog(@"signal content:5");

    //3、取消订阅
    [disposable dispose];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
