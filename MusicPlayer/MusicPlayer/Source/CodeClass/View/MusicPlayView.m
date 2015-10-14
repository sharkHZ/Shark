//
//  MusicPlayView.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/5.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicPlayView.h"



@implementation MusicPlayView

-(instancetype)init{
    if (self = [super init]) {
        [self p_setup];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)p_setup
{
    // 模糊背景图
    
    self.bgPic = [[UIImageView alloc]init];
    self.bgPic.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight );
    [self addSubview:self.bgPic];
    // 1.ScorollView
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.frame = CGRectMake(0, 0,kScreenWidth , kScreenWidth+100);
    self.mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, CGRectGetHeight(self.mainScrollView.frame));
    self.mainScrollView.backgroundColor = [UIColor clearColor    ];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.alwaysBounceHorizontal = YES; // 打开水平滚动
    self.mainScrollView.alwaysBounceVertical = NO; // 关闭垂直滚动
//    self.mainScorllView.bounces = NO;
    [self addSubview:self.mainScrollView];
    
    // ImageView
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.frame = CGRectMake(0, 0, kScreenWidth,kScreenWidth);
    self.headImageView.backgroundColor  = [UIColor redColor];
  
    [self.mainScrollView addSubview:self.headImageView];
    
    // tableView
    self.lyricTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, CGRectGetHeight(self.mainScrollView.frame)) style:(UITableViewStylePlain)];
//    UIImageView *imageView=[[UIImageView alloc]init];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[MusicPlayTools shareMusicPlay].model.blurPicUrl]] ;
//    [self.lyricTableView setBackgroundView:imageView];
    self.lyricTableView.backgroundColor = [UIColor clearColor];
    [self.mainScrollView addSubview:self.lyricTableView];
    
    // 歌词label
    self.lyricLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.mainScrollView.frame), CGRectGetMaxY(self.headImageView.frame), kScreenWidth, 100)];
//    self.lyricLabel.backgroundColor = [UIColor redColor];
    [self.mainScrollView addSubview:_lyricLabel];
    self.lyricLabel.textAlignment = NSTextAlignmentCenter;
    self.lyricLabel.numberOfLines = 0;
    self.lyricLabel.textColor = [UIColor blueColor];
    // 当前播放时间
    self.curTimeLabel = [[UILabel alloc] init];
    self.curTimeLabel.frame = CGRectMake(CGRectGetMinX(self.lyricLabel.frame),
                                         CGRectGetMaxY(self.lyricLabel.frame),
                                         60, 30);
//    self.curTimeLabel.backgroundColor = [UIColor greenColor];
    
    [self addSubview:self.curTimeLabel];
    
    // 播放进度条
    self.progressSlider = [[UISlider alloc] init];
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.curTimeLabel.frame),
                                           CGRectGetMinY(self.curTimeLabel.frame),
                                           kScreenWidth - CGRectGetWidth(self.curTimeLabel.frame)*2, 30);
    [self addSubview:self.progressSlider];
    [self.progressSlider addTarget:self action:@selector(progressSliderAction:) forControlEvents:UIControlEventValueChanged];
    self.progressSlider.thumbTintColor = [UIColor redColor];
    // 总时间
    self.totleTiemLabel = [[UILabel alloc] init];
    self.totleTiemLabel.frame = CGRectMake(CGRectGetMaxX(self.progressSlider.frame),
                                            CGRectGetMinY(self.progressSlider.frame),
                                            CGRectGetWidth(self.curTimeLabel.frame),
                                            CGRectGetHeight(self.curTimeLabel.frame));
//    self.totleTiemLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.totleTiemLabel];
    
    // 上一首的按钮
    self.lastSongButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.lastSongButton.frame = CGRectMake(CGRectGetMaxX(self.curTimeLabel.frame)+30,
                                           kScreenHeight - 30 - 94,
                                           30,
                                           30);
    self.lastSongButton.backgroundColor = [UIColor clearColor];
    [self.lastSongButton setBackgroundImage:[UIImage imageNamed:@"icons-last"] forState:UIControlStateNormal];
    [self addSubview:self.lastSongButton];
    [self.lastSongButton addTarget:self action:@selector(lastSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 播放/暂停的按钮
    self.playPauseButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.playPauseButton.frame = CGRectMake(CGRectGetMaxX(self.lastSongButton.frame)+ 50,
                                            CGRectGetMinY(self.lastSongButton.frame),
                                            CGRectGetWidth(self.lastSongButton.frame),
                                            CGRectGetHeight(self.lastSongButton.frame));
//    self.playPauseButton.backgroundColor = [UIColor cyanColor];
//    [self.playPauseButton setTitle:@"正在播放" forState:UIControlStateNormal];
    [self addSubview:self.playPauseButton];
    [self.playPauseButton addTarget:self action:@selector(playPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 下一首的按钮
    self.nextSongButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.nextSongButton.frame = CGRectMake(CGRectGetMaxX(self.playPauseButton.frame) + 50,
                                           CGRectGetMinY(self.lastSongButton.frame),
                                           CGRectGetWidth(self.lastSongButton.frame),
                                           CGRectGetHeight(self.lastSongButton.frame));
    self.nextSongButton.backgroundColor = [UIColor clearColor];
    [self.nextSongButton setBackgroundImage:[UIImage imageNamed:@"icons-next"] forState:UIControlStateNormal];
    [self addSubview:self.nextSongButton];
    [self.nextSongButton addTarget:self action:@selector(nextSongButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 模式button
    self.playModel = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playModel.frame = CGRectMake(CGRectGetMinX(self.lastSongButton.frame) - 60, CGRectGetMinY(self.lastSongButton.frame), CGRectGetWidth(self.lastSongButton.frame), CGRectGetHeight(self.lastSongButton.frame));
//    self.playModel.backgroundColor = [UIColor redColor];
    [self.playModel setBackgroundImage:[UIImage imageNamed:@"icons-pass"] forState:UIControlStateNormal];
    [self addSubview:_playModel];
    [self.playModel addTarget:self action:@selector(playModelControlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // listButton
    self.playList = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playList.frame = CGRectMake(CGRectGetMaxX(self.nextSongButton.frame) + 30, CGRectGetMinY(self.nextSongButton.frame), CGRectGetWidth(self.lastSongButton.frame), CGRectGetHeight(self.lastSongButton.frame));
//    self.playList.backgroundColor = [UIColor redColor];
    [self.playList setBackgroundImage:[UIImage imageNamed:@"icons-list"] forState:UIControlStateNormal];
    [self addSubview:_playList];
    [self.playList addTarget:self action:@selector(playListAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)playListAction:(UIButton *)sender{
    [self.delegate playListAction];
}
- (void)playModelControlButtonAction:(UIButton *)sender
{
    [self.delegate playModelControlButtonAction];
}
- (void)progressSliderAction:(UISlider *)sender{
    [self.delegate progressSlider:sender];
}
- (void)lastSongButtonAction:(UIButton *)sender{
    [self.delegate lastSongAction];
}
- (void)nextSongButtonAction:(UIButton *)sender{
    [self.delegate nextSongAction];
}
- (void)playPauseButtonAction:(UIButton *)sender{
    [self.delegate playPauseButton];
}
@end






