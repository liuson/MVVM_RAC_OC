//
//  LoginView.h
//  MVVM_RAC_OC
//
//  Created by wayfor on 2018/10/31.
//  Copyright © 2018年 LIUSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLoginViewModel.h"

@interface LoginView : UIView

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (weak, nonatomic) IBOutlet UILabel *loginHUD;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property(nonatomic,strong) LKLoginViewModel *loginVM;

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;



@end
