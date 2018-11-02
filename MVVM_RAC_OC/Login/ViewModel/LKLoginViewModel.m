//
//  LKLoginViewModel.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/31.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "LKLoginViewModel.h"

@implementation LKLoginViewModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    @weakify(self);
    self.usernameSignal = [[RACObserve(self, username) map:^id (NSString *text) {
        @strongify(self);
        return @([self isValidUsername:text]);
    }] distinctUntilChanged] ;
    
    self.passwordSignal = [[RACObserve(self, password) map:^id (NSString *text) {
        @strongify(self);
        return @([self isValidPassword:text]);
    }] distinctUntilChanged] ;
    
    self.loginEnableSignal = [RACSignal combineLatest:@[self.usernameSignal,self.passwordSignal] reduce:^id (NSNumber *usernameValid,NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithEnabled:self.loginEnableSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSLog(@"login-1");
        return [self loginSignal];
    }];
    
//    self.ditLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        @strongify(self)
//        return [self loginActionSignal];
//    }];
//    
}

//-(RACSignal *)loginActionSignal{
//    @weakify(self);
//    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        @strongify(self);
//        [self pushNavWay];
//        [subscriber sendCompleted];
//        return nil;
//    }];
//}

//- (void)pushNavWay{
//    if ([]) {
//        <#statements#>
//    }
//}

- (RACSignal *)loginSignal{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self loginWithUsername:self.username password:self.password complete:^(BOOL success) {
             NSLog(@"login-2");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            });
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length >= 2;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length >= 6;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password complete:(void (^)(BOOL))loginResult{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL success = [username isEqualToString:@"lk"] && [password isEqualToString:@"123456"];
        loginResult(success);
    });
}

@end
