//
//  MusicListTableViewController.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/5.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicPlayViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
@interface MusicListTableViewController ()

@property(nonatomic,strong)NSArray * dataArray;

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [[GetDataTools shareGetData] getDataWithURL:kURL PassValue:^(NSArray *array) {
        self.dataArray = array;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icons-loadin"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icons-main"] style:UIBarButtonItemStyleDone target:self action:@selector(leftAction:)];
}
- (void)leftAction:(UIBarButtonItem *)sender{
    
}
-(void)rightAction:(UIBarButtonItem *)sender
{
    LoginViewController *one = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:one animated:YES];

//     数据插入的方法
//    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    [testObject save];
//    // 数据查询的方法
//    AVQuery *query = [AVQuery queryWithClassName:@"TestObject"];
//    [query whereKey:@"foo" equalTo:@"bar"];
//    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        if (!object) {
//            NSLog(@"getFirstObject 请求失败。");
//        } else {
//            // 查询成功
//            NSLog(@"%@",object);
//            
//            
//        }
//    }];
    
}
- (void)viewWillAppear:(BOOL)animated

{  if (YES == [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
    
    //已登录 注销
    [self p_setupLogoutButtonItem];
    self.navigationItem.title =   [GetDataTools shareGetData].getUserLogin;
    
    
}else{
    
    //已注销 登陆
    [self p_setupLoginButtonItem];
    self.navigationItem.title = @"";
}
    if ([GetDataTools shareGetData].index == 0) {
        return;
    }
    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:[GetDataTools shareGetData].index inSection:0];
    
    [self.tableView selectRowAtIndexPath:tempIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
- (void)p_setupLoginButtonItem
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆"  style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icons-loadin"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
}
-(void)rightButtonAction:(UIBarButtonItem *)sender
{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    __block MusicListTableViewController * userVC = self;
    
    loginVC.mblock = ^(NSString * name){
        [userVC p_setupLogoutButtonItem];
        
    };
    UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self presentViewController:loginNC animated:YES completion:nil];
    
    
}


- (void)p_setupLogoutButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icons-cancel"] style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction1:)];
}
-(void)rightButtonAction1:(UIBarButtonItem *)sender
{
    NSLog(@"注销............");
    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:@"是否确认注销："delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定",nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //设置登陆按钮
    [self p_setupLoginButtonItem];
    self.navigationItem.title = @"";
    [alert show];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    

   
   

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 152;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicPlayViewController  * MusicPlayVC  =[MusicPlayViewController shareMusicPlay];
    // ***********************************
//    MusicPlayVC.currentIndex = ^(NSInteger curIndex) {
//        NSIndexPath *path = [NSIndexPath indexPathForRow:curIndex inSection:0];
//        [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
//    };
    // ***********************************
    
    
    MusicPlayVC.index = indexPath.row;
    
    [self.navigationController pushViewController:MusicPlayVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
