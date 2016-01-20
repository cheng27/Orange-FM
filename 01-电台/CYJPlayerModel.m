//
//  CYJPlayerModel.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJPlayerModel.h"

@implementation CYJPlayerModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
//        self.musicianName = dict[@"musicianName"];
//        self.musicName = dict[@"musicName"];
//        self.imageUrl = dict[@"imageUrl"];
//        self.musicUrl = dict[@"musicUrl"];
    }
    return self;
}

+ (instancetype)initWithImageUrl:(NSString *)imageUrl withMusicName:(NSString *)musicName withMusicUrl:(NSString *)musicUrl andMusicianName:(NSString *)musicianName
{
    CYJPlayerModel *model = [[CYJPlayerModel alloc] init];
    model.imageUrl = imageUrl;
    model.musicName = musicName;
    model.musicianName = musicianName;
    model.musicUrl = musicUrl;
    return model;
}




@end
