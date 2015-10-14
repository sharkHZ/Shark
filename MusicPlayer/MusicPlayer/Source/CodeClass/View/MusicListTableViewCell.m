//
//  MusicListTableViewCell.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/5.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "MusicListTableViewCell.h"

@implementation MusicListTableViewCell

-(void)setModel:(MusicInfoModel *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.songNameLable.text = model.name;
    self.songNameLable.textAlignment = NSTextAlignmentCenter;
    self.songNameLable.font = [UIFont systemFontOfSize:20.0];
    self.songNameLable.textColor = [UIColor cyanColor];
    self.authorNameLabel.text = model.singer;
    self.authorNameLabel.textAlignment = NSTextAlignmentRight;
    self.authorNameLabel.font = [UIFont systemFontOfSize:14.0];
    self.authorNameLabel.textColor = [UIColor orangeColor];
    UIImageView *imageView=[[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]] ;
    [self setBackgroundView:imageView];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
