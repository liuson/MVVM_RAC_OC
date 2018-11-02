//
//  LKLoginController.m
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/31.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import "LKLoginController.h"
#import "LoginView.h"
#import "EnterController.h"

@interface LKLoginController ()

@end

@implementation LKLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"RAC";
    
    LoginView *loginView = [[LoginView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [loginView.loginVM.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"success - vc");
        BOOL success = [x boolValue];
        if (success) {
            //跳转
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                EnterController *enterVC = [[EnterController alloc] init];
                [self.navigationController pushViewController:enterVC animated:YES];
            });
            
        }
    }];
    [self.view addSubview:loginView];
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
