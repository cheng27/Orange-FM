//
//  CYJPlayer.h
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CYJPlayer : NSObject
@property (nonatomic,strong) AVPlayer *player;

+ (CYJPlayer *)sharePlayer;

@end
