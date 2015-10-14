//
//  GetDataTools.m
//  MusicPlayer
//
//  Created by 李志强 on 15/10/6.
//  Copyright (c) 2015年 李志强. All rights reserved.
//

#import "GetDataTools.h"

static GetDataTools * gd = nil;

@implementation GetDataTools

+(instancetype)shareGetData
{
    if (gd == nil) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            gd = [[GetDataTools alloc] init];
        });
    }
    return gd;
}

-(void)getDataWithURL:(NSString *)URL PassValue:(PassValue)passValue
{
    dispatch_queue_t globl_t = dispatch_get_global_queue(0, 0);
    
    dispatch_async(globl_t, ^{
        NSArray * array =[NSArray arrayWithContentsOfURL:[NSURL URLWithString:URL]];
        
        for (NSDictionary * dict in array) {
            MusicInfoModel * model = [[MusicInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArray addObject:model];
        }
        
        passValue(self.dataArray);
    });
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(MusicInfoModel *)getModelWithIndex:(NSInteger)index
{
    return self.dataArray[index];
}

-(void)setUserLogin:(User*)sender
{
    NSUserDefaults *user = [[NSUserDefaults alloc] init];
    [user setObject:sender.UserName forKey:@"Entity"];
    
    
}
-(NSString *)getUserLogin
{
    NSUserDefaults *user =[[NSUserDefaults alloc] init];
    
    return  [user objectForKey:@"Entity" ];
}

@end
