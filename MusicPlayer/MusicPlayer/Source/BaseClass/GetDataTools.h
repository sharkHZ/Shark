//
//  GetDataTools.h
//  MusicPlayer
//
//  Created by 李志强 on 15/10/6.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "MusicPlayTools.h"
typedef void (^PassValue)(NSArray * array);

@interface GetDataTools : NSObject
@property(nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic, assign)NSInteger index;
+(instancetype)shareGetData;

-(void)getDataWithURL:(NSString *)URL PassValue:(PassValue)passValue;


-(MusicInfoModel *)getModelWithIndex:(NSInteger)index;
//设置数据
-(void)setUserLogin:(User*)sender;
-(NSString *)getUserLogin;
@end




