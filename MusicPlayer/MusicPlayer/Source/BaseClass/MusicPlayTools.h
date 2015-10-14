//
//  MusicPlayTools.h
//  MusicPlayer
//
//  Created by 李志强 on 15/10/6.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MusicPlayToolsDelegate <NSObject>

-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;

-(void)endOfPlayAction;

@end

@interface MusicPlayTools : NSObject
@property(nonatomic,strong)AVPlayer * player;
@property(nonatomic,strong)MusicInfoModel * model;
@property(nonatomic,weak)id<MusicPlayToolsDelegate> delegate;

// 单例方法
+(instancetype)shareMusicPlay;

// 播放音乐
-(void)musicPlay;

// 暂停音乐
-(void)musicPause;

// 准备播放
-(void)musicPrePlay;

// 跳转
-(void)seekToTimeWithValue:(CGFloat)value;

// 歌词解析
- (NSMutableArray *)getMusicLyricArray;

// 歌词和时间同步
- (NSInteger)getIndexWithCurTime;

@end




