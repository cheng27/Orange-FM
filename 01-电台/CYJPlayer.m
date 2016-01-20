//
//  CYJPlayer.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJPlayer.h"

@implementation CYJPlayer

static CYJPlayer *myPlayer = nil;
+ (CYJPlayer *)sharePlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myPlayer = [[self alloc] init];
    });
    return myPlayer;
}

- (id)init
{
    if (self = [super init]) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}

@end
