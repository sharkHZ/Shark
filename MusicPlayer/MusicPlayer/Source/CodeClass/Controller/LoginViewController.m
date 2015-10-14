//
//  LoginViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/10/13.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterViewController.h"
#import "User.h"
#import <AVOSCloud/AVOSCloud.h>
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic , strong) LoginView * lv;
@end

@implementation LoginViewController
- (void)loadView{
    self.lv = [[LoginView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = _lv;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lv.regiBUtton addTarget:self action:@selector(regiBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lv.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 响应者 1 有返回值，返回yes， 2 ，释放第一响应者
    [textField resignFirstResponder];
    return YES;
}
- (void)regiBUttonAction:(UIButton *)sender{
    RegisterViewController *one = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:one animated:YES];
}
- (void)loginButtonAction:(UIButton *)sender{
    User *c = [[User alloc] init];
    AVQuery *query = [AVQuery queryWithClassName:@"TestObject"];
    [query whereKey:@"UserName" equalTo:self.lv.loginTextField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // 检索成功
            NSLog(@"Successfully retrieved %lu posts.", (unsigned long)objects.count);
            
            if(objects.count == 0){
                UIAlertView *alertv = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账号或密码错误："delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                [alertv show];
                return ;
            }
            
            
            NSDictionary *dict = [objects valueForKey:@"localData"];
            
            for (NSDictionary   *s in dict) {
                
                NSLog(@"%@",[s valueForKey:@"UserName"]);
                
                [c setValuesForKeysWithDictionary:s];
                
            }
            
            
            
            NSLog(@"%@=======%@=====%@",dict,c.UserName,c.PassWord);
            
            
            if ([self.lv.loginTextField.text isEqualToString:c.UserName] && [self.lv.passTextField.text isEqualToString:c.PassWord]) {
                
                
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSString *name = self.lv.loginTextField.text;
                
                [[GetDataTools shareGetData]setUserLogin:c];
                
                self.mblock(name);
                
                UIAlertView*success = [[UIAlertView alloc]initWithTitle:@"提示"message:@"登陆成功:"delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                [success show];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
                
                
                NSLog(@"loginsuccess");
            }
            else if ([self.lv.loginTextField.text isEqualToString:@""] && [self.lv.passTextField.text isEqualToString:@""])
            {
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账号或密码为空:"delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"账号或密码错误："delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                [alert show];
            }
            
            
            
            
            
        }
        
        else {
            // 输出错误信息
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

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
