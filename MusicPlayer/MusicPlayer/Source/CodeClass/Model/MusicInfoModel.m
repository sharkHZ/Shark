//
//  MusicInfoModel.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/6.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicInfoModel.h"

@implementation MusicInfoModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        self.timeLyric = [value componentsSeparatedByString:@"\n"];
    
    }
}

@end
