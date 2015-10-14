//
//  RegisterView.h
//  MusicPlayer
//
//  Created by lanou3g on 15/10/13.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *passLabel;
@property(nonatomic,strong)UILabel *passagainLabel;
@property(nonatomic,strong)UILabel *emilLabel;
@property(nonatomic,strong)UILabel *teleLabel;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *passTextField;
@property(nonatomic,strong)UITextField *passaginTextField;
@property(nonatomic,strong)UITextField *emilTextField;
@property(nonatomic,strong)UITextField *teleTextField;
@property (nonatomic , strong) UIButton *button;

@end
