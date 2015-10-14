//
//  MusicPlayView.h
//  MusicPlayer
//
//  Created by 李志强 on 15/10/5.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicPlayViewDelegate <NSObject>

- (void)lastSongAction;
- (void)nextSongAction;
- (void)playPauseButton;
- (void)progressSlider:(UISlider *)sender;
- (void)playModelControlButtonAction;
- (void)playListAction;
@end
@interface MusicPlayView : UIView



@property(nonatomic,strong)UIScrollView  * mainScrollView;
@property (nonatomic , strong) UIImageView *bgPic;
@property(nonatomic,strong)UIImageView * headImageView;
@property(nonatomic,strong)UITableView * lyricTableView;
@property(nonatomic,strong)UILabel * curTimeLabel;
@property(nonatomic,strong)UISlider * progressSlider;
@property(nonatomic,strong)UILabel * totleTiemLabel;

@property(nonatomic,strong)UIButton * lastSongButton;
@property(nonatomic,strong)UIButton * playPauseButton;
@property(nonatomic,strong)UIButton * nextSongButton;


@property (nonatomic , strong) UILabel * lyricLabel;
@property (nonatomic , strong) UIButton * playModel;
@property (nonatomic , strong) UIButton * playList;


@property (nonatomic , strong) UISlider * voiceSlider;
@property (nonatomic , strong) UIButton * voiceButton;
@property (nonatomic , weak)id <MusicPlayViewDelegate> delegate;


@end
