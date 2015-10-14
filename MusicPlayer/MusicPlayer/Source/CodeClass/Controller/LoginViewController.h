//
//  LoginViewController.h
//  MusicPlayer
//
//  Created by lanou3g on 15/10/13.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^myBlock)(NSString *);
@interface LoginViewController : UIViewController
@property(nonatomic,copy)myBlock mblock;
@end
