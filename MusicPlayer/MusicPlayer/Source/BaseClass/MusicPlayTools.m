//
//  MusicPlayTools.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/6.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicPlayTools.h"

static MusicPlayTools * mp = nil;

@interface MusicPlayTools ()
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation MusicPlayTools

+(instancetype)shareMusicPlay
{
    if (mp == nil) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            mp = [[MusicPlayTools alloc] init];
        });
    }
    return mp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[AVPlayer alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endOfPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
// 播放结束后的方法,由代理具体实现行为.
-(void) endOfPlay:(NSNotification *)sender
{
    [self.delegate endOfPlayAction];
}
// 准备播放
-(void)musicPrePlay
{
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    AVPlayerItem * item = [[ AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.model.mp3Url]];
    
    NSLog(@"%@",self.model.mp3Url);
    
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    
    [self.player replaceCurrentItemWithPlayerItem:item];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        switch ([[change valueForKey:@"new"] integerValue]) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"不知道什么错误");
                break;
            case AVPlayerItemStatusReadyToPlay:
                [self.timer invalidate];
                self.timer = nil;
                [self musicPlay];
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"准备失败");
                break;
            default:
                break;
        }
    }
}

-(void)musicPlay
{
    if (self.timer != nil) {
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    [self.player play];
}

-(void)timerAction:(NSTimer * )sender
{
    [self.delegate getCurTiem:[self valueToString:[self getCurTime]] Totle:[self    valueToString:[self getTotleTime]] Progress:[self getProgress]];
}

// 暂停方法
-(void)musicPause
{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
}

// 跳转方法
-(void)seekToTimeWithValue:(CGFloat)value
{
    // 先暂停
    [self musicPause];
    
    // 跳转
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            [self musicPlay];
        }
    }];
}

// 获取当前的播放时间
-(NSInteger)getCurTime
{
    if (self.player.currentItem) {
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }
    return 0;
}
// 获取总时长
-(NSInteger)getTotleTime
{
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else
    {
        return totleTime.value /totleTime.timescale;
    }
}
// 获取当前播放进度
-(CGFloat)getProgress
{
    return (CGFloat)[self getCurTime]/ (CGFloat)[self getTotleTime];
}

-(NSString *)valueToString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value/60,value%60];
}
// 歌词解析
- (NSMutableArray *)getMusicLyricArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString * str in self.model.timeLyric) {
        if (str.length == 0) {
            continue;
        }
        
        MusicLyricModel *model = [[MusicLyricModel alloc]init];
        if([[str substringToIndex:1] isEqualToString:@"["])
        {
        model.lyricTime = [str substringWithRange:NSMakeRange(1, 5)];
        NSRange range = [str rangeOfString:@"]"];
        model.lyricStr = [str substringFromIndex:range.location + 1];
        [array addObject:model];
        }
//        else{
//            if([[str substringToIndex:1] isEqualToString:@"作"])
//            {
//                model.lyricTime = [str substringWithRange:NSMakeRange(1, 5)];
//                NSRange range = [str rangeOfString:@"作"];
//                model.lyricStr = [str substringFromIndex:range.location ];
//                [array addObject:model];
//                
//            }
//        }
//        
    }
    return array;

}

// 歌词和时间同步
- (NSInteger)getIndexWithCurTime{
    NSInteger index = 0;
    NSString *curTime = [self valueToString:[self getCurTime]];
    for (NSString *str in self.model.timeLyric) {
        if (str.length == 0) {
            continue;
        }
        if ([curTime isEqualToString:[str substringWithRange:NSMakeRange(1, 5)]]) {
            return index;
        }
        index ++;
    }
    return -1;
}
@end
