//
//  MusicPlayViewController.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/5.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "MusicPlayView.h"
#import "UMSocial.h"
@interface MusicPlayViewController ()<MusicPlayToolsDelegate,MusicPlayViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) MusicPlayView * rv;
@property (nonatomic , strong) NSArray * lyricArray;
@property (nonatomic , strong)UIView *controlView;
@property (nonatomic,strong)UIButton *handleButton;
@property(nonatomic,strong)UIButton *loopButton;
@property(nonatomic,strong)UIButton *randomButton;
@property (nonatomic , strong) UILabel *handleLabel;
@property (nonatomic , strong) UILabel *loopLabel;
@property (nonatomic , strong) UILabel *randomLabel;
@end

static MusicPlayViewController * mp = nil;

@implementation MusicPlayViewController

-(void)loadView
{
    self.rv = [[MusicPlayView alloc]init];
    self.view = _rv;
}

+(instancetype)shareMusicPlay
{
    if (mp == nil) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            mp = [[MusicPlayViewController alloc] init];
        });
    }
    return mp;
}
// *****************************************
- (void)viewWillDisappear:(BOOL)animated{
    [GetDataTools shareGetData].index = self.index;
}
// *****************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_pre];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [MusicPlayTools shareMusicPlay].delegate = self;
    // 切割封面
    self.rv.headImageView.layer.cornerRadius = kScreenWidth/2;
    self.rv.headImageView.layer.masksToBounds = YES;
    // 遵循View的自己设置的代理
    self.rv.delegate = self;
    // 做判断,观察者
    [[MusicPlayTools shareMusicPlay].player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.rv.lyricTableView.dataSource = self;
    self.rv.lyricTableView.delegate = self;
    
//   ********************
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<Back" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icons-share"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction)];
    [self.rv.playModel addTarget:self action:@selector(playModelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rv.playList addTarget:self action:@selector(playListAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)playModelAction{
    
}
- (void)playListAction{
    // 播放模式控制View
    self.controlView = [[UIView alloc]init];
    self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playList.frame), CGRectGetMidY(self.rv.playList.frame), CGRectGetWidth(self.rv.playList.frame), 0);
    self.controlView.backgroundColor = [UIColor whiteColor];
    
    [self.rv addSubview:self.controlView];
}
- (void)p_pre
{
    self.rv.nextSongButton.backgroundColor = [UIColor clearColor];
    
    self.rv.voiceSlider.value = 10;
    [self.rv.voiceButton setBackgroundImage:[UIImage imageNamed:@"icons-voice"] forState:UIControlStateNormal];

    self.rv.playModel.tag = 100;
//
//    //初始化歌词界面背景View为ImageView
//    self.mpView.lyricTableView.backgroundView = [[UIImageView alloc]init];
//    
    
    // 播放模式控制View
    self.controlView = [[UIView alloc]init];
    self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playModel.frame), CGRectGetMidY(self.rv.playModel.frame), CGRectGetWidth(self.rv.playModel.frame), 0);
    self.controlView.backgroundColor = [UIColor whiteColor];
    
    [self.rv addSubview:self.controlView];
    
    
    // 单曲循环按钮
    self.handleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.handleButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.rv.playModel.frame), CGRectGetHeight(self.rv.playModel.frame));
    [self.handleButton setBackgroundImage:[UIImage imageNamed:@"icons-single"] forState:UIControlStateNormal];
    [self.handleButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.handleLabel.frame = CGRectMake(CGRectGetMaxX(self.handleButton.frame), CGRectGetMinY(self.handleButton.frame), CGRectGetWidth(self.handleButton.frame), 30);
    self.handleLabel.text = @"单曲循环";
    
    // 顺序播放按钮
    self.loopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loopButton.frame = CGRectMake(CGRectGetMinX(self.handleButton.frame), CGRectGetMaxY(self.handleButton.frame), CGRectGetWidth(self.handleButton.frame), CGRectGetHeight(self.handleButton.frame));
    [self.loopButton setBackgroundImage:[UIImage imageNamed:@"icons-circulate"] forState:UIControlStateNormal];
    [self.loopButton addTarget:self action:@selector(loopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loopLabel.frame = CGRectMake(CGRectGetMaxX(self.loopButton.frame), CGRectGetMinY(self.loopButton.frame), CGRectGetWidth(self.loopButton.frame), 30);
    self.loopLabel.text = @"顺序播放";
    // 随机播放按钮
    self.randomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.randomButton.frame = CGRectMake(CGRectGetMinX(self.loopButton.frame), CGRectGetMaxY(self.loopButton.frame), CGRectGetWidth(self.loopButton.frame), CGRectGetHeight(self.loopButton.frame));
    [self.randomButton setBackgroundImage:[UIImage imageNamed:@"icons-random"] forState:UIControlStateNormal];
    [self.randomButton addTarget:self action:@selector(randomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.randomLabel.frame = CGRectMake(CGRectGetMaxX(self.randomButton.frame), CGRectGetMinY(self.randomButton.frame), CGRectGetWidth(self.randomButton.frame),30);
    self.randomLabel.text = @"随机播放";
}

- (void)rightBarButtonItemAction{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"561b602467e58eddb2000db7"
                                      shareText:nil
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToEmail,UMShareToFacebook,UMShareToSms ,UMShareToQzone,nil]
                                       delegate:nil];
}
//- (void)back:(UIBarButtonItem *)sender {
//    
//    self.currentIndex(self.index);
//    [self.navigationController popViewControllerAnimated:YES];
//}
//***************************

// 当设置的观察者rate 判断value值 是零时playPauseButton的title设置为(已经暂停)否则就是(正在播放)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"rate"]) {
        if ([[change valueForKey:@"new"]integerValue] == 0) {
            [self.rv.playPauseButton setBackgroundImage:[UIImage imageNamed:@"icons-play"] forState:UIControlStateNormal];
        }else{
            [self.rv.playPauseButton setBackgroundImage:[UIImage imageNamed:@"icons-pause"] forState:UIControlStateNormal];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [self p_play];
    
}
- (void)p_play{
    if ([[MusicPlayTools shareMusicPlay].model isEqual:[[GetDataTools shareGetData] getModelWithIndex:self.index]]) {
        return;
    }
    [MusicPlayTools shareMusicPlay].model = [[GetDataTools shareGetData] getModelWithIndex:self.index];
    
    [[MusicPlayTools shareMusicPlay] musicPrePlay];
    // 设置模糊背景图
    [self.rv.bgPic sd_setImageWithURL:[NSURL URLWithString:[MusicPlayTools shareMusicPlay].model.blurPicUrl]];
    
    // 重新设置一下UIimageView的旋转角度
    
    self.rv.headImageView.transform = CGAffineTransformMakeRotation(M_PI*200);
    
    // 设置歌曲封面
    [self.rv.headImageView sd_setImageWithURL:[NSURL URLWithString:[MusicPlayTools shareMusicPlay].model.picUrl]];
    // 设置歌词
    self.lyricArray = [[MusicPlayTools shareMusicPlay] getMusicLyricArray];
    [self.rv.lyricTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Delegate方法 
-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress
{
    // 显示
    self.rv.curTimeLabel.text = curTime;
    self.rv.curTimeLabel.textColor = [UIColor blueColor];
    self.rv.curTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.rv.totleTiemLabel.text = totleTime;
    self.rv.totleTiemLabel.textColor = [UIColor blueColor];
    self.rv.totleTiemLabel.textAlignment = NSTextAlignmentCenter;
    self.rv.progressSlider.value = progress;
    
    // 让图片转起来
    [UIView animateWithDuration:0.5 animations:^{
         self.rv.headImageView.transform = CGAffineTransformRotate(self.rv.headImageView.transform, M_PI/180);
    }];
   // 歌词跳啊跳
    NSInteger index =[[MusicPlayTools shareMusicPlay] getIndexWithCurTime];
    if (index == -1) {
        return;
    }
    if (index != 0) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
        UITableViewCell *lastCell = [self.rv.lyricTableView cellForRowAtIndexPath:lastIndexPath];
        lastCell.textLabel.font = [UIFont systemFontOfSize:17.0];
        lastCell.alpha = 0.1;
    }
    NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
//   self.rv.lyricLabel.text = [self.rv.lyricLabel cellForRowAtIndexPath:tmpIndexPath].textLabel.text;
    self.rv.lyricLabel.text = [self.rv.lyricTableView cellForRowAtIndexPath:tmpIndexPath].textLabel.text;
    
    [self.rv.lyricTableView selectRowAtIndexPath:tmpIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    UITableViewCell *cell = [self.rv.lyricTableView cellForRowAtIndexPath:tmpIndexPath];
//    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:23.0];
//    if (index != 0) {
//        UITableViewCell *cell2 = [self.rv.lyricTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index - 1 inSection:0]];
//        cell2.textLabel.font = [UIFont systemFontOfSize:17];
//    }
//    
//    [self.rv.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
//    
//    UITableViewCell *cell = [self.rv.lyricTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    cell.textLabel.font = [UIFont systemFontOfSize:25];
    

    
}
// 上一曲
- (void)lastSongAction{
    if (self.index > 0) {
        self.index -- ;
    }else{
       self.index =  [GetDataTools shareGetData].dataArray.count - 1;
    }
    
    [self p_play];
}
// 下一曲
- (void)nextSongAction{
    
//    [[MusicPlayTools shareMusicPlay]musicPlay];
    
    if (self.index == [GetDataTools shareGetData].dataArray.count - 1) {
        self.index= 0 ;
    }else{
        self.index ++;
    }
    
    [self p_play];
}
// 暂停

- (void)playPauseButton{
//    if (self.rv.tag == 0) {
//        [[MusicPlayTools shareMusicPlay] musicPause];
//       
//    }else{
//        [[MusicPlayTools shareMusicPlay] musicPlay];
//       
//    }
//    self.rv.tag = !self.rv.tag;
    if ([MusicPlayTools shareMusicPlay].player.rate == 0) {
        [self.rv.playPauseButton setBackgroundImage:[UIImage imageNamed:@"icons-play"] forState:UIControlStateNormal];
        [[MusicPlayTools shareMusicPlay]musicPlay];
    }else{
        [self.rv.playPauseButton setBackgroundImage:[UIImage imageNamed:@"icons-pause"] forState:UIControlStateNormal];
        [[MusicPlayTools shareMusicPlay]musicPause];
    }
}
// 自动跳转下一曲
- (void)endOfPlayAction{
//    [self nextSongAction];
//    [self playPauseButton];
//    [self playPauseButton];
    if (self.rv.playModel.tag == 100) {
        NSLog(@"1");
        [self nextSongAction];
        self.rv.mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
//        [self nextSongAction];
    }else if (self.rv.playModel.tag == 101){
        NSLog(@"2");
        [[MusicPlayTools shareMusicPlay] seekToTimeWithValue:0];
//        [self p_play];
    }else if (self.rv.playModel.tag == 102){
        NSLog(@"3");
        self.index = arc4random()%[GetDataTools shareGetData].dataArray.count;
        [self p_play];
    }

}
// 进度条
- (void)progressSlider:(UISlider *)sender{
    [[MusicPlayTools shareMusicPlay]seekToTimeWithValue:sender.value];
}
// 歌词部分
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lyricArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.alpha = 0;
    cell.textLabel.text = [self.lyricArray[indexPath.row] valueForKey:@"lyricStr"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor cyanColor];
    cell.textLabel.highlightedTextColor = [UIColor greenColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//     cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    return cell;
}

#pragma mark 播放模式ButtonAction
- (void)playModelControlButtonAction
{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playModel.frame), CGRectGetMinY(self.rv.playModel.frame) - CGRectGetHeight(self.rv.playModel.frame), CGRectGetWidth(self.rv.playModel.frame), CGRectGetHeight(self.rv.playModel.frame) * 3);
        
        [self.rv bringSubviewToFront:self.controlView];
        
    } completion:^(BOOL finished) {
        
//        self.controlView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        self.controlView.layer.shadowOffset = CGSizeMake(-5, 5);
//        self.controlView.layer.shadowOpacity = 3;
        [self addControlButton];
    }];
    
}
//- (void)playListAction
//{
//    [UIView animateWithDuration:0.2f animations:^{
//        
//        self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playList.frame), CGRectGetMinY(self.rv.playList.frame) - CGRectGetHeight(self.rv.playList.frame), CGRectGetWidth(self.rv.playList.frame), CGRectGetHeight(self.rv.playList.frame) * 3);
//        
//        [self.rv bringSubviewToFront:self.controlView];
//        
//    } completion:^(BOOL finished) {
//        
//        //        self.controlView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//        //        self.controlView.layer.shadowOffset = CGSizeMake(-5, 5);
//        //        self.controlView.layer.shadowOpacity = 3;
//        [self addControlButton];
//    }];
//    
//}

// 单曲循环
- (void)handleButtonAction:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playModel.frame), CGRectGetMidY(self.rv.playModel.frame), CGRectGetWidth(self.rv.playModel.frame), 0);
        [self removeControlButton];
        [self.rv.playModel setBackgroundImage:[UIImage imageNamed:@"icons-single"] forState:UIControlStateNormal];
        [self.controlView addSubview:_handleLabel];
    } completion:^(BOOL finished) {
        self.rv.playModel.tag = 101;
    }];
}

// 顺序播放
- (void)loopButtonAction:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playModel.frame), CGRectGetMidY(self.rv.playModel.frame), CGRectGetWidth(self.rv.playModel.frame), 0);
        [self removeControlButton];
        [self.rv.playModel setBackgroundImage:[UIImage imageNamed:@"icons-circulate"] forState:UIControlStateNormal];
//        [self.controlView addSubview:_loopButton];
    } completion:^(BOOL finished) {
        self.rv.playModel.tag = 100;
    }];
}

// 随机播放
- (void)randomButtonAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.controlView.frame = CGRectMake(CGRectGetMinX(self.rv.playModel.frame), CGRectGetMidY(self.rv.playModel.frame), CGRectGetWidth(self.rv.playModel.frame), 0);
        [self removeControlButton];
        [self.rv.playModel setBackgroundImage:[UIImage imageNamed:@"icons-random"] forState:UIControlStateNormal];
        [self.controlView addSubview:_randomLabel];
    } completion:^(BOOL finished) {
        self.rv.playModel.tag = 102;
    }];
}
-(void)addControlButton
{
    [self.controlView addSubview:self.handleButton];
    [self.controlView addSubview:self.randomButton];
    [self.controlView addSubview:self.loopButton];
//    [self.controlView addSubview:_handleLabel];
//    [self.controlView addSubview:_randomButton];
//    [self.controlView addSubview:_loopButton];
}
- (void)removeControlButton
{
    
    [self.handleButton removeFromSuperview];
    [self.randomButton removeFromSuperview];
    [self.loopButton removeFromSuperview];
//    [self.handleLabel removeFromSuperview];
//    [self.randomButton removeFromSuperview];
//    [self.loopLabel removeFromSuperview];
}




















@end
