//
//  Header.h
//  01-电台
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 阿六. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */
#define kMark 6
#define  kSpace 10
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kViewWidth self.playerView.frame.size.width
#define kViewHeight self.playerView.frame.size.height
#define kBtnWidth     [UIScreen mainScreen].bounds.size.width/5
#define kTabBarColor  [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255/0 alpha:1]
#define kDBFileName   @"music.db"

#import "UIView+FrameExtension.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>
#import <UIImage+GIF.h>
#import <AFHTTPSessionManager.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <SDCycleScrollView.h>
#import "ScrollDetailVC.h"
#import "CYJPlayer.h"
#import "DXAlertView.h"
#import "CYJPlayerModel.h"
