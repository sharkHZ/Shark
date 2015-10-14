//
//  LoginView.m
//  MusicPlayer
//
//  Created by lanou3g on 15/10/13.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}

-(void)p_setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    //
    self.loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 80, 30)];
    // self.loginLabel.backgroundColor = [UIColor cyanColor];
    self.loginLabel.text = @"用户名:";
    [self addSubview:_loginLabel];
    //
    self.passLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loginLabel.frame), CGRectGetMaxY(self.loginLabel.frame)+20, CGRectGetWidth(self.loginLabel.frame), CGRectGetHeight(self.loginLabel.frame))];
    self.passLabel.text =@"密码:";
    // self.loginLabel.backgroundColor = [UIColor cyanColor];
    [self addSubview:_passLabel];
    //
    self.loginTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.loginLabel.frame)+20, CGRectGetMinY(self.loginLabel.frame), CGRectGetWidth(self.frame)-CGRectGetWidth(self.loginLabel.frame)-60, CGRectGetHeight(self.loginLabel.frame))];
    self.loginTextField.placeholder =@"请输入用户名";
    self.loginTextField.clearsOnBeginEditing = YES;
    self.loginTextField.keyboardType =UIKeyboardTypeEmailAddress;
    self.loginTextField.borderStyle= UITextBorderStyleRoundedRect;
    self.loginTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_loginTextField];
    
    //
    self.passTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.loginTextField.frame), CGRectGetMinY(self.passLabel.frame), CGRectGetWidth(self.loginTextField.frame), CGRectGetHeight(self.passLabel.frame))];
    self.passTextField.placeholder =@"请输入密码";
    self.passTextField.clearsOnBeginEditing = YES;
    self.passTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.passTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_passTextField];
    // 登陆
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.frame = CGRectMake(CGRectGetMinX(self.passLabel.frame), CGRectGetMaxY(self.passLabel.frame)+40, CGRectGetWidth(self.passLabel.frame)+40, 50);
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    // [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self addSubview:_loginButton];
    
    //注册
    self.regiBUtton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.regiBUtton.frame = CGRectMake(CGRectGetMaxX(self.loginButton.frame)+30, CGRectGetMinY(self.loginButton.frame), CGRectGetWidth(self.loginButton.frame), CGRectGetHeight(self.loginButton.frame));
    [self.regiBUtton setBackgroundImage:[UIImage imageNamed:@"register_button.png"] forState:UIControlStateNormal];
    [self addSubview:_regiBUtton];
    
    
    
    
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
