
//
//  LoginView.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/31.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:nil options:nil].lastObject;
        self.frame = frame;
        
        [self _initView];
    }
    return self;
}

- (void)_initView{
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = self.center;
    [self addSubview:_activityIndicatorView];
    
    self.loginVM = [[LKLoginViewModel alloc] init];
    
    RAC(self.loginVM,username) = self.usernameTF.rac_textSignal;
    RAC(self.loginVM,password) = self.passwordTF.rac_textSignal;
    
    // 应用宏定义控制控件的UI
    RAC(self.usernameTF, backgroundColor) = [self.loginVM.usernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];
    RAC(self.passwordTF, backgroundColor) = [self.loginVM.passwordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];

    @weakify(self);
    [self.loginVM.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSLog(@"success - view");

        BOOL success = [x boolValue];
        self.loginBtn.enabled = YES;
        if (success) {
//            [self goToLoginSuccessVC];
            self.loginHUD.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.loginHUD.hidden = YES;
                
            });
        }
    }];
    
    [[self.loginVM.loginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行，显示loading");
            [self.activityIndicatorView startAnimating];
        } else {
            NSLog(@"执行完成，隐藏loading");
            [self.activityIndicatorView stopAnimating];
        }
    }];
    [self.loginVM.connectionErrors subscribeNext:^(NSError *error) {
        NSLog(@"错误了，给个提示 error is %@",error);
    }];
    
    RAC(self.loginBtn, enabled) = self.loginVM.loginEnableSignal;

    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self endEditing:YES];
        self.loginBtn.enabled = NO;
        //        self.loginFailureLabel.hidden = YES;
    }] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.loginVM.loginCommand execute:@2];
    }] ;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
