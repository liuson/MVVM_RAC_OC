//
//  LKLoginViewModel.h
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/31.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LKLoginViewModel : NSObject

// property
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

// signal
@property (nonatomic, strong) RACSignal *usernameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;
@property (nonatomic, strong) RACSignal *loginEnableSignal;
@property (nonatomic, strong) RACSignal *connectionErrors;

// command
@property (nonatomic, strong) RACCommand *loginCommand;

//@property (nonatomic,strong) RACCommand *ditLoginCommand;


@end
