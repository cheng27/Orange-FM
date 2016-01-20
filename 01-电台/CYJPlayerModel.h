//
//  CYJPlayerModel.h
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYJPlayerModel : NSObject

//歌曲图片Url
@property(nonatomic ,strong)NSString *imageUrl;
//歌曲名字
@property(nonatomic ,strong)NSString *musicName;
//歌手名字
@property(nonatomic ,strong)NSString *musicianName;
//歌曲MP3地址Url
@property(nonatomic ,strong)NSString *musicUrl;

+ (instancetype)initWithImageUrl:(NSString *)imageUrl withMusicName:(NSString *)musicName withMusicUrl:(NSString *)musicUrl andMusicianName:(NSString *)musicianName;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
