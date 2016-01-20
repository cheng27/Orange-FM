//
//  MyTarBar.h
//  01-电台
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MyTabBar : UITabBarController

+ (MyTabBar *)shareMyTabBar;
@property (nonatomic,strong) MyTabBar *myTabBar;
//放tabBar的view
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *playBtn;
//播放器的view
@property (nonatomic,strong) UIView *playerView;

//-------------------播放器控件--------------------/
//返回btn
@property (nonatomic,strong) UIButton *backBtn;

//中间Image
@property (nonatomic,strong) UIImageView *middleImage;

//Image中间图层
@property (nonatomic,strong) UIView *midImgBigView;

//图层中间空缺
@property (nonatomic,strong) UIView *minImgSmallView;

//歌曲进度
@property (nonatomic,strong) UISlider *musicSlide;

//当前时间
@property (nonatomic,strong) UILabel *currentTime;

//歌曲总时长
@property (nonatomic,strong) UILabel *durationTime;

//音乐名字
@property (nonatomic,strong) UILabel *musicName;

//歌手名字
@property (nonatomic,strong) UILabel *singerName;

//收藏按钮
//@property (nonatomic,strong) UIButton *collectBtn;

//音量按钮
@property (nonatomic,strong) UIButton *volumeBtn;

//音量滑块
@property (nonatomic,strong) UISlider *volumeSlide;

//上一首
@property (nonatomic,strong) UIButton *previousBtn;

//下一首
@property (nonatomic,strong) UIButton *nextBtn;

//播放或暂停
@property (nonatomic,strong) UIButton *playOrPause;

//歌曲列表
@property (nonatomic,strong) UIButton *musicListBtn;

//歌曲列表的tableView
@property (nonatomic,strong) UITableView *musicListTable;

//退出歌曲列表按钮
@property (nonatomic,strong) UIButton *backPlayerBtn;

//歌曲列表的数组
@property (nonatomic,strong) NSMutableArray *musicListArr;

@property (nonatomic,strong) AVPlayerItem *playerItem;
@property (nonatomic,strong) NSTimer *middleImageTimer;

@end
