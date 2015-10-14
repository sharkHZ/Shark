//
//  RegisterViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/10/13.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "User.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) RegisterView *rv;
@end

@implementation RegisterViewController
- (void)loadView{
    self.rv = [[RegisterView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = _rv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rv.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self p_delegate];
}
-(void)p_delegate
{
    self.rv.nameTextField.delegate = self;
    self.rv.passTextField.delegate = self;
    self.rv.passaginTextField.delegate = self;
    self.rv.emilTextField.delegate = self;
    
    self.rv.teleTextField.delegate = self;
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 响应者 1 有返回值，返回yes， 2 ，释放第一响应者
    [textField resignFirstResponder];
    return YES;
}

- (void)buttonAction:(UIButton *)sender{
    
    if ([self.rv.nameTextField.text isEqualToString:@""] || [self.rv.passTextField.text isEqualToString:@""]) {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账号和密码为空："delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    else if ([self.rv.nameTextField.text isEqualToString:self.rv.passTextField.text ]) {
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账号和密码相同："delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
        
        return;
    }else if (NO == [self.rv.passTextField.text  isEqualToString:self.rv.passaginTextField.text]) {
        //注册时，两次输入的密码必须一致
        
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"两次输入密码不一致："delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
        
        return;
    }else
    {
        
        
        AVQuery *query = [AVQuery queryWithClassName:@"TestObject"];
        [query whereKey:@"UserName" equalTo:self.rv.nameTextField.text];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // 检索成功
                NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
                
                if(objects.count != 0){
                    UIAlertView *alertv = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账号已存在："delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                    [alertv show];
                    return ;
                }
                
                NSLog(@" 正在注册...");
                
                AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
                [testObject setObject:self.rv.nameTextField.text forKey:@"UserName"];
                [testObject setObject:self.rv.passTextField.text forKey:@"PassWord"];
                [testObject setObject:self.rv.emilTextField.text forKey:@"Emil"];
                [testObject setObject:self.rv.teleTextField.text forKey:@"TelePhone"];
                [testObject save];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            else {
                // 输出错误信息
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        
        
        
    }
    
    
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
