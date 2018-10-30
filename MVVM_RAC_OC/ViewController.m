//
//  ViewController.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/29.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "ViewController.h"
//#import <RACSignal.h>
//#import <RACSubscriber.h>
//#import <RACDisposable.h>
//#import <RACEvent.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

  
//    [self createSignal:@"create one"];
//    [self combineLaterSignal];
//    [self reduceSignal];
//    [self thenSignal];
    [self zipWithSignal];
    
    
    
    
}

#pragma create
- (void)createSignal:(NSString *)content{
    NSLog(@"signal content:1");

    //1、创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //send signal
        NSLog(@"signal content:2");
        
        [subscriber sendNext:content];
        NSLog(@"signal content:3");
        
        [subscriber sendCompleted];
        NSLog(@"signal content:4");
        
        return nil;
    }];
    
    NSLog(@"signal content:5");
    
    //2、订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        //收到信号
        NSLog(@"signal content:6");
        
        NSLog(@"signal content:%@",x);
    }];
    
    NSLog(@"signal content:7");
    
    //3、取消订阅
    [disposable dispose];
}

#pragma mark -combineLater
/******
 将多信号合并起来，并且拿到各个信号的最新的值，必须每个合并的signal至少都有过一次sendnext。才会触发合并信号（combinelater与zipwith不同的是，每次只拿到各个信号最新值）
 **********/
- (void)combineLaterSignal{
    NSLog(@"A");
    RACSignal *combineLaterA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        NSLog(@"B");
//        [subscriber sendCompleted];

        [subscriber sendNext:@2];
        NSLog(@"C");
        return nil;
    }];
    NSLog(@"D");
    RACSignal *combineLaterB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        [subscriber sendNext:signalTwo];
//        [subscriber sendCompleted];
        NSLog(@"E");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@3];
            NSLog(@"F");
        });
        NSLog(@"G");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@5];
            NSLog(@"H");
        });
        return nil;
    }];
    
    NSLog(@"I");
    RACSignal *combineSignal = [combineLaterA combineLatestWith:combineLaterB];
    [combineSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"J");
        RACTupleUnpack(NSNumber *a,NSNumber *b) = x;
        NSLog(@"combinelater:%@  %@",a,b);
        
        
    }];
    
    NSLog(@"K");
    
}

#pragma mark -reduce 聚合
- (void)reduceSignal{
    //信号发出的内容是元组，把信号发出元组的值聚合成一个值，一般都是先组合在聚合
     NSLog(@"A");
    RACSignal *reduceSignalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         NSLog(@"B");
        [subscriber sendNext:@1];
        return nil;
    }];
     NSLog(@"C");
    RACSignal *reduceSignalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
         NSLog(@"D");
        [subscriber sendNext:@3];
        return nil;
    }];
     NSLog(@"E");
    RACSignal *reduceSingal = [RACSignal combineLatest:@[reduceSignalA,reduceSignalB] reduce:^id (NSNumber *a,NSNumber *b){
         NSLog(@"F");
        return [NSString stringWithFormat:@"%@ - %@",a,b];
    }];
     NSLog(@"G");
    [reduceSingal subscribeNext:^(id  _Nullable x) {
        NSLog(@"H");
        NSLog(@"reduce:%@",x);
    }];
     NSLog(@"I");
}

#pragma mark -map 数组处理
#pragma mark -filter 过滤
#pragma mark -then 下一个
- (void)thenSignal{
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal * _Nonnull{
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"then:%@",x);
    }]  ;
}

#pragma mark -zipWith 压缩
- (void)zipWithSignal{
    NSLog(@"A");
    RACSignal *zipSignalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"B");

        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        return nil;
    }];
    NSLog(@"C");

    RACSignal *zipSignalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"D");

        [subscriber sendNext:@3];
        [subscriber sendNext:@4];
        return nil;
    }];
    NSLog(@"E");

    RACSignal *zipSignal = [zipSignalA zipWith:zipSignalB];
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"F");

        RACTupleUnpack(NSNumber *a, NSNumber *b) = x;
        NSLog(@"zip with:%@  %@",a,b);
    }];
    
    NSLog(@"G");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
