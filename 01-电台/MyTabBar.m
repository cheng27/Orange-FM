//
//  MyTarBar.m
//  01-电台
//
//  Created by qingyun on 16/1/10.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "MyTabBar.h"
#import "Header.h"
#import "Masonry.h"
#import "CYJFileManager.h"



@interface MyTabBar ()<UITableViewDataSource,UITableViewDelegate>
//选中的tabBar按钮
@property (nonatomic ,retain) UIButton *selectedBtn;
@property (nonatomic,strong) NSDictionary *todayMusicDict;
@property (nonatomic,assign) double angle;
@property (nonatomic,assign) double tagAngle;
@property (nonatomic,assign) CGFloat current;
@property (nonatomic,assign) NSInteger musicListIndex;
@property (nonatomic,assign) NSIndexPath *cellSelectedIndex;

@end

@implementation MyTabBar

static MyTabBar *myTabBar = nil;
+ (MyTabBar *)shareMyTabBar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myTabBar = [[self alloc] init];
    });
    return myTabBar;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //删除现有的tabBar
    CGRect rect = self.tabBar.frame;
    [self.tabBar removeFromSuperview];
    
    //添加自己的视图
    self.bottomView = [[UIView alloc]init];
    _bottomView.frame = rect;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    //添加TabBar的按钮和label
    [self addBtnAndLabel];
   
    //添加播放器视图
    [self addPlayerView];
    
    //添加播放器控件
    [self addSubViewsForPlayerView];
    
    [self updateViewConstraints];
    
    _angle = 0;
    _middleImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(Timer) userInfo:nil repeats:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTodayMusic:) name:@"todayMusicDic" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendFindeMusic:) name:@"findMusicList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didMusicFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
#pragma mark - 通知方法的实现
- (void)sendTodayMusic:(NSNotification *)notification
{
    [self.musicListArr removeAllObjects];
    self.todayMusicDict = notification.userInfo[@"musicData"];
    _playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.todayMusicDict[@"filename"]]];
    [[CYJPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:_playerItem];
    [self updateTodayMusic];
    [self appearThePlayer];
}
- (void)sendFindeMusic:(NSNotification *)notification
{
    self.musicListArr = notification.userInfo[@"findMusic"];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.musicListArr[0][@"filename"]]];
    [[CYJPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self updateFindMusic];
    [self.middleImage sd_setImageWithURL:[NSURL URLWithString:self.musicListArr[0][@"songphoto"]]];
    self.musicName.text = self.musicListArr[0][@"songname"];
    self.singerName.text = self.musicListArr[0][@"songer"];
    [self.musicListTable reloadData];
    [self appearThePlayer];
    
}


#pragma mark - 懒加载
//歌曲列表的数组
-(NSMutableArray *)musicListArr{
    if (_musicListArr == nil) {
        _musicListArr = [NSMutableArray array];
    }
    return _musicListArr;
}
- (NSDictionary *)todayMusicDict
{
    if (_todayMusicDict == nil) {
        _todayMusicDict = [NSDictionary dictionary];
    }
    return _todayMusicDict;
}
#pragma mark - 添加自定义的视图
//添加自定义的tabBar
- (void)addBtnAndLabel
{
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(2 * kBtnWidth,-24, kBtnWidth, kBtnWidth);
    [self.playBtn setImage:[UIImage imageNamed:@"TabBar.png"] forState:UIControlStateNormal];
    //self.playBtn.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.playBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    //self.playBtn.layer.borderWidth = 3;
    self.playBtn.layer.cornerRadius = _bottomView.frame.size.width / 10;
    [self.playBtn addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    [self.bottomView addSubview:self.playBtn];
    
    for (int i = 0; i < 4; i++) {
        CGFloat x = i * _bottomView.frame.size.width / 5;
        
        if (i == 2 || i == 3) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((i+1) * kBtnWidth,0, kBtnWidth, _bottomView.frame.size.height)];
            
            NSString *imageName = [NSString stringWithFormat:@"TabBar%d", i + 1];
            NSString *imageNameSel = [NSString stringWithFormat:@"TabBar%dSel", i + 1];
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageNameSel] forState:UIControlStateSelected];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-9, 0, 0, 0);
            [_bottomView addSubview:btn];
            
            btn.tag = i + 100;//设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x,0, kBtnWidth ,_bottomView.frame.size.height)];
            
            NSString *imageName = [NSString stringWithFormat:@"TabBar%d", i + 1];
            [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            btn.imageEdgeInsets = UIEdgeInsetsMake(-9, 0, 0, 0);
            [_bottomView addSubview:btn];
            
            btn.tag = i + 100;//设置按钮的标记, 方便来索引当前的按钮,并跳转到相应的视图
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            //设置刚进入时,第一个按钮为选中状态
            if (i == 0) {
                btn.selected = YES;
                self.selectedBtn = btn;  //设置该按钮为选中的按钮
                [_selectedBtn setImage:[UIImage imageNamed:@"TabBarSel1"] forState:UIControlStateSelected];
            }
            
        }
    }
    
    for (int i = 0; i<4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, _bottomView.frame.size.height-15, _bottomView.frame.size.width/5, 15)];
        
        NSArray *arrays = @[@"阅读",@"音乐",@"潮流",@"我的"];
        
        label.text = arrays[i];
        label.font = [UIFont fontWithName:@"迷你简魏碑" size:14];
        label.textColor = [UIColor colorWithRed:98/255.0 green:147/255.0 blue:228/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [[_bottomView viewWithTag:i+100] addSubview:label];
    }
}
//添加播放器视图
- (void)addPlayerView
{
    _playerView = [[UIView alloc] init];
    _playerView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    _playerView.backgroundColor = [UIColor colorWithRed:191 /255.0 green:202 / 255.0 blue:230 / 255.0 alpha:1];
    _playerView.hidden = YES;
    [self.view addSubview:_playerView];
}
//添加播放器控件
- (void)addSubViewsForPlayerView
{
    //返回button
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.backBtn.frame = CGRectMake(kSpace*2,kSpace*3, kSpace*3  , kSpace*3);
    [self.backBtn setImage:[UIImage imageNamed:@"quit.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView addSubview:self.backBtn];
    
    //中间Image
    self.middleImage = [[UIImageView alloc]init];
    self.middleImage.frame = CGRectMake(kViewWidth/4 , kViewHeight/14 , kViewWidth/2, kViewWidth/2);
    self.middleImage.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
    self.middleImage.layer.cornerRadius = kViewWidth/4;
    self.middleImage.layer.masksToBounds = YES;
    [self.playerView addSubview:self.middleImage];
    
    //Image中间图层
    self.midImgBigView = [[UIView alloc]init];
    self.midImgBigView.frame = CGRectMake(self.middleImage.width/3, self.middleImage.height/3, self.middleImage.width/3, self.middleImage.height/3);
    self.midImgBigView.backgroundColor = [UIColor colorWithRed:230 /255.   green:230 / 255. blue:230 / 255. alpha:1.000];
    //    self.midImageBigView.alpha = .5;
    self.midImgBigView.layer.cornerRadius = self.middleImage.height/6;
    self.midImgBigView.layer.masksToBounds = YES;
    [self.middleImage addSubview:self.midImgBigView];
    
    //图层中间空缺
    self.minImgSmallView = [[UIView alloc]init];
    self.minImgSmallView.frame = CGRectMake(self.midImgBigView.width/4, self.midImgBigView.height/4, self.midImgBigView.width/2, self.midImgBigView.height/2);
    self.minImgSmallView.backgroundColor = [UIColor blackColor];
    self.minImgSmallView.layer.cornerRadius = self.midImgBigView.height/4;
    self.minImgSmallView.layer.masksToBounds = YES;
    self.minImgSmallView.alpha = 1;
    [self.midImgBigView addSubview:self.minImgSmallView];
    
    //音乐名字
    self.musicName = [[UILabel alloc]init];
    self.musicName.frame = CGRectMake(kViewWidth/8, CGRectGetMaxY(self.middleImage.frame)+kSpace, kViewWidth/8*6, 3*kSpace);
   // self.musicName.backgroundColor = [UIColor orangeColor];
    self.musicName.textAlignment = NSTextAlignmentCenter;
    self.musicName.font = [UIFont fontWithName:@"迷你简魏碑" size:18];
    [self.playerView addSubview:self.musicName];
    
    //乐人名字
    self.singerName = [[UILabel alloc]init];
    self.singerName.frame = CGRectMake(kViewWidth/4, CGRectGetMaxY(self.musicName.frame)+2*kSpace, kViewWidth/2, 3*kSpace);
    //    self.musicianName.backgroundColor = [UIColor orangeColor];
    self.singerName.textAlignment = NSTextAlignmentCenter;
    self.singerName.textColor = [UIColor lightGrayColor];
    self.singerName.font = [UIFont fontWithName:@"迷你简魏碑" size:18];
    [self.playerView addSubview:self.singerName];
    
    //收藏按钮
//    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.collectBtn.frame = CGRectMake((kViewWidth/2)+3*kSpace, CGRectGetMaxY(self.singerName.frame)+4*kSpace, kSpace*3, kSpace*3);
//    [self.collectBtn setImage:[UIImage imageNamed:@"收藏.png"] forState:UIControlStateNormal];
//    [self.collectBtn addTarget:self action:@selector(collectButtonaction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.playerView addSubview:self.collectBtn];
    
    //音量按钮
    self.volumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.volumeBtn.frame = CGRectMake(3*kSpace, CGRectGetMaxY(self.singerName.frame)+1*kSpace ,kSpace * 3, kSpace * 3);
    [self.volumeBtn setImage:[UIImage imageNamed:@"音量"] forState:UIControlStateNormal];
    [self.playerView addSubview:self.volumeBtn];
    //音量滑块
    self.volumeSlide = [[UISlider alloc] init];
    self.volumeSlide.frame = CGRectMake(6*kSpace, CGRectGetMaxY(self.singerName.frame)+1*kSpace, 20*kSpace, 3*kSpace);
    [self.volumeSlide setThumbImage:[UIImage imageNamed:@"iconfont-huakuai"] forState:UIControlStateNormal];
    //self.volumeSlide.transform = CGAffineTransformMakeRotation(M_PI *1.5);
    [self.volumeSlide addTarget:self action:@selector(changeVolume:) forControlEvents:UIControlEventTouchDragInside];
    self.volumeSlide.value = 0.3;
    [self.playerView addSubview:self.volumeSlide];
    
    //musiclist
    self.musicListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.musicListBtn.frame = CGRectMake(CGRectGetMaxX(_playerView.frame)-6*kSpace, CGRectGetMaxY(self.singerName.frame)+1*kSpace, kSpace*3, kSpace*3);
    [self.musicListBtn setImage:[UIImage imageNamed:@"歌单.png"] forState:UIControlStateNormal];
    [self.musicListBtn addTarget:self action:@selector(musicListButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView addSubview:self.musicListBtn];
    
    //currentimelabel
    self.currentTime = [[UILabel alloc]init];
    self.currentTime.frame = CGRectMake(kSpace, CGRectGetMaxY(self.musicListBtn.frame)+kSpace*5, 6*kSpace, 3*kSpace);
    self.currentTime.text = @"00:00";
    //    self.currenTimeLabel.backgroundColor = [UIColor orangeColor];
    [self.playerView addSubview:self.currentTime];
    
    //slider
    self.musicSlide = [[UISlider alloc]init];
    self.musicSlide.frame = CGRectMake(CGRectGetMaxX(self.currentTime.frame), CGRectGetMaxY(self.musicListBtn.frame)+kSpace*5, self.playerView.frame.size.width-14*kSpace, 3*kSpace);
    [self.musicSlide setThumbImage:[UIImage imageNamed:@"圆矩形.png"] forState:UIControlStateNormal];
    [self.musicSlide addTarget:self action:@selector(changeValues:) forControlEvents:UIControlEventValueChanged];
    [self.playerView addSubview:self.musicSlide];
    
    //durationtimelabel
    self.durationTime = [[UILabel alloc]init];
    self.durationTime.frame = CGRectMake(CGRectGetMaxX(self.musicSlide.frame)+kSpace, CGRectGetMaxY(self.musicListBtn.frame)+kSpace*5, 6*kSpace, 3*kSpace);
    //    self.durationTimeLabel.backgroundColor = [UIColor orangeColor];
    self.durationTime.text = @"00:00";
    [self.playerView addSubview:self.durationTime];
    
    //上一首
    self.previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousBtn.frame = CGRectMake(kViewWidth/3-3*kSpace, CGRectGetMaxY(self.durationTime.frame)+4*kSpace, 3*kSpace, 3*kSpace);
    [self.previousBtn setImage:[UIImage imageNamed:@"上一首.png"] forState:UIControlStateNormal];
    [self.previousBtn addTarget:self action:@selector(previousBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView addSubview:self.previousBtn];
    
    //播放/暂停
    self.playOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPause.frame = CGRectMake(kViewWidth/2-7*kSpace/2, CGRectGetMaxY(self.durationTime.frame)+2*kSpace, 7*kSpace, 7*kSpace);
    [self.playOrPause setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateNormal];
    [self.playOrPause addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView addSubview:self.playOrPause];
    
    //下一首
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.frame = CGRectMake(kViewWidth/3*2, CGRectGetMaxY(self.durationTime.frame)+4*kSpace, 3*kSpace, 3*kSpace);
    [self.nextBtn setImage:[UIImage imageNamed:@"下一首.png"] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerView addSubview:self.nextBtn];
    
}
- (void)updateViewConstraints
{
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playerView).with.offset(kSpace*2);
        make.top.equalTo(_playerView).with.offset(kSpace*4);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_middleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playerView).with.offset(kSpace *5);
        make.centerX.equalTo(_playerView);
        make.size.mas_equalTo(CGSizeMake(kViewWidth/2, kViewWidth/2));
    }];
    [_midImgBigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_middleImage);
        make.size.mas_equalTo(CGSizeMake(_middleImage.width/3, _middleImage.width/3));
    }];
    [_minImgSmallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_middleImage);
        make.size.mas_equalTo(CGSizeMake(_midImgBigView.width/2, _midImgBigView.width/2));
    }];
    [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_playerView);
        make.top.equalTo(_middleImage.mas_bottom).with.offset(kSpace);
        make.left.equalTo(_playerView).with.offset(kSpace*8);
        make.bottom.equalTo(_singerName.mas_top).with.offset(kSpace);
    }];
    [_volumeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backBtn);
//        make.left.equalTo(_playerView.mas_left).with.offset(kSpace *2);
//        make.top.equalTo(_singerName.mas_bottom).with.offset(kSpace);
        make.centerY.equalTo(_volumeSlide);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_volumeSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_singerName.mas_bottom).with.offset(kSpace);
        make.left.equalTo(_volumeBtn.mas_right).with.offset(kSpace *2);
        //make.right.equalTo(_musicListBtn.mas_left).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(kSpace *20, kSpace *3));
    }];
    [_musicListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_volumeSlide.mas_bottom).with.offset(kSpace);
//        make.left.equalTo(_playerView.mas_left).with.offset(9*kSpace);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(_volumeBtn);
        make.right.equalTo(_playerView.mas_right).with.offset(-30);
    }];
//    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_musicListBtn);
//        make.right.equalTo(_playerView.mas_right).with.offset(-90);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
    [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playerView.mas_left).with.offset(kSpace *1);
        make.top.equalTo(_musicListBtn.mas_bottom).with.offset(kSpace*3);
        make.right.equalTo(_musicSlide.mas_left).with.offset(-kSpace);
       // make.size.mas_equalTo(CGSizeMake(6*kSpace, 3*kSpace));
        make.centerY.equalTo(_musicSlide);
    }];
    [_musicSlide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_currentTime);
        make.right.equalTo(_durationTime.mas_left).with.offset(-kSpace*2);
    }];
    [_durationTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_playerView.mas_right).with.offset(-kSpace);
        make.centerY.equalTo(_currentTime);
    }];
    [_playOrPause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_musicSlide.mas_bottom).with.offset(kSpace *2);
        make.centerX.equalTo(_playerView);
        make.bottom.equalTo(_playerView.mas_bottom).with.offset(-kSpace *4);
//        make.left.equalTo(_previousBtn.mas_right).with.offset(kSpace *2);
//        make.right.equalTo(_nextBtn.mas_left).with.offset(kSpace * 2);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_previousBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playerView.mas_left).with.offset(kSpace * 6);
        make.centerY.equalTo(_playOrPause);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(_previousBtn);
        make.right.equalTo(_playerView.mas_right).with.offset(-kSpace *6);
    }];
    
    [super updateViewConstraints];
}
-(void)addMusicListTab{
    self.musicListTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.playerView.height+40, self.playerView.width, self.playerView.height/3*2-40) style:UITableViewStylePlain];
    self.musicListTable.alpha = .8;
    self.musicListTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.playerView addSubview:self.musicListTable];
    self.musicListTable.hidden = YES;
    self.musicListTable.delegate = self;
    self.musicListTable.dataSource = self;
    
    self.backPlayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backPlayerBtn.frame = CGRectMake(self.playerView.width/6*5, self.playerView.height, self.playerView.width/6, 40);
    [self.backPlayerBtn setImage:[UIImage imageNamed:@"MusicTabBack.png"] forState:UIControlStateNormal];
    self.backPlayerBtn.backgroundColor = [UIColor whiteColor];
    self.backPlayerBtn.alpha = .8;
    [self.backPlayerBtn addTarget:self action:@selector(musicListTabBack:) forControlEvents:UIControlEventTouchUpInside];
    self.backPlayerBtn.hidden = YES;
    [self.playerView addSubview:self.backPlayerBtn];
    
}


#pragma mark - btn点击事件
//切换视图控制器
- (void)clickBtn:(UIButton *)button {
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    
    //2.再将当前按钮设置为选中
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = button;
    
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = button.tag - 100;
    
    if (self.selectedIndex == 0) {
        
        [_selectedBtn setImage:[UIImage imageNamed:@"TabBarSel1"] forState:UIControlStateSelected];
    }else if (self.selectedIndex == 1){
        
        [_selectedBtn setImage:[UIImage imageNamed:@"TabBarSel2"] forState:UIControlStateSelected];
    }else if (self.selectedIndex == 2){
        
        [_selectedBtn setImage:[UIImage imageNamed:@"TabBarSel3"] forState:UIControlStateSelected];
        
    }else if(self.selectedIndex == 3){
        [_selectedBtn setImage:[UIImage imageNamed:@"TabBarSel4"] forState:UIControlStateSelected];
    }
    
}
//进入播放界面
-(void)playButtonAction:(UIButton *)sender{
    
    [self appearThePlayer];
    
}
//退出播放界面
- (void)backBtnAction:(UIButton *)sender
{
    [self dismissThePlayer];
}
//收藏
- (void)collectButtonaction:(UIButton *)sender
{
    //NSLog(@"收藏");
   // [self insertValue];
    
}
- (void)insertValue
{
    CYJPlayerModel *model = [CYJPlayerModel initWithImageUrl:nil withMusicName:_musicName.text withMusicUrl:nil andMusicianName:_singerName.text];
    //获取单例对象
//    CYJFileManager *manager = [CYJFileManager shareManager];
//    if ([manager insertData:model]) {
//        NSLog(@"数据插入成功");
//    }
    [[CYJFileManager shareManager] insertData:model];
}
//声音大小的调整
- (void)changeVolume:(UISlider *)slider
{
    [self musicVolume:slider.value];
}
- (void)musicVolume:(float)value
{
    [CYJPlayer sharePlayer].player.volume = value;
}
//歌单
- (void)musicListButtonAction:(UIButton *)sender
{
    NSLog(@"歌单");
    if (self.musicListArr.count != 0) {
        [self addMusicListTab];
        [self appearTheTab];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"今日音乐人只有一首歌" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//歌曲进度
- (void)changeValues:(UISlider *)slider
{
    if (_playOrPause.tag == 1 ) {
        CGFloat t = slider.value *CMTimeGetSeconds(self.playerItem.duration);
        [[CYJPlayer sharePlayer].player seekToTime:CMTimeMake(t, 1)completionHandler:^(BOOL finished) {
            [[CYJPlayer sharePlayer].player pause];
        }];
    }else
    {
        CGFloat t = slider.value * CMTimeGetSeconds(self.playerItem.duration);
        [[CYJPlayer sharePlayer].player seekToTime:CMTimeMake(t, 1)completionHandler:^(BOOL finished) {
            [[CYJPlayer sharePlayer].player play];
        }];
    }
}
//上一首
- (void)previousBtnAction:(UIButton *)sender
{
    NSLog(@"上一首");
    if (self.musicListArr.count != 0) {
        NSInteger arrayIndex = _musicListIndex;
        if (arrayIndex == 0) {
            arrayIndex = self.musicListArr.count - 1;
        }else
        {
            arrayIndex = arrayIndex - 1;
        }
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.musicListArr[arrayIndex][@"filename"]]];
        [[CYJPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
        self.musicListIndex = arrayIndex;
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"今日音乐人只有一首歌" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//播放或暂停
- (void)playOrPauseAction:(UIButton *)sender
{
    NSLog(@"播放/暂停");
    if (sender.tag) {
        sender.tag = 0;
        [self.middleImageTimer setFireDate:[NSDate distantPast]];
        [sender setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [[CYJPlayer sharePlayer].player play];
    }else
    {
        sender.tag = 1;
        [self.middleImageTimer setFireDate:[NSDate distantFuture]];
        [sender setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        [[CYJPlayer sharePlayer].player pause];
    }
}
- (void)didMusicFinished
{
    if (self.musicListArr.count == 0) {
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.todayMusicDict[@"filename"]]];
        [[CYJPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self updateTodayMusic];
    }else
    {
        [self nextButtonAction:nil];
    }
}
//下一首
- (void)nextButtonAction:(UIButton *)sender
{
    NSLog(@"下一首");
    if (self.musicListArr.count != 0) {
        NSInteger arrayIndex = self.musicListIndex;
        if (arrayIndex == self.musicListArr.count - 1) {
            arrayIndex = 0;
        }else
        {
            arrayIndex = arrayIndex + 1;
        }
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.musicListArr[arrayIndex][@"filename"]]];
        [[CYJPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
        self.musicListIndex = arrayIndex;
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"今日音乐人只有一首歌" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//退出播放列表
- (void)musicListTabBack:(UIButton *)sender
{
    [self dismissTheTab];
}
- (void)Timer
{
    _angle = _angle + 0.005;
    if (_angle > M_PI * 2) {
        _angle = 0;
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(_angle);
    self.middleImage.transform = transform;
}
#pragma mark - 显示/退出播放器界面
//显示播放界面
-(void)appearThePlayer{
    // 1.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    self.playerView.hidden = NO;
    
    // 2.动画显示
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.playerView.frame;
        frame.origin.y = 0;
        self.playerView.frame = frame;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
    
}
//退出播放界面
-(void)dismissThePlayer{
    // 1.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    
    // 2.动画显示
    [UIView animateWithDuration:.5 animations:^{
        CGRect frame = self.playerView.frame;
        frame.origin.y = self.view.frame.size.height;
        self.playerView.frame = frame;
    } completion:^(BOOL finished) {
        
        self.playerView.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}
//显示歌单列表
-(void)appearTheTab{
    // 0.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    self.backPlayerBtn.hidden = NO;
    self.musicListTable.hidden = NO;
    // 动画显示
    
    [UIView animateWithDuration:.5 animations:^{
        self.backPlayerBtn.y = self.playerView.height/3;
        self.musicListTable.y = self.playerView.height/3+40;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
    
}
//退出播放列表
-(void)dismissTheTab{
    // 0.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    window.userInteractionEnabled = NO;
    // 动画显示
    
    [UIView animateWithDuration:.5 animations:^{
        self.backPlayerBtn.y = self.playerView.height;
        self.musicListTable.y = self.playerView.height+40;
    } completion:^(BOOL finished) {
        self.backPlayerBtn.hidden = YES;
        self.musicListTable.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}

#pragma mark - 更新播放数据
- (void)updateTodayMusic
{
    self.musicSlide.value = 0;
    [self.middleImage sd_setImageWithURL:[NSURL URLWithString:self.todayMusicDict[@"songphoto"]]];
    self.musicName.text = self.todayMusicDict[@"songname"];
    self.singerName.text = self.todayMusicDict[@"songer"];
    self.playOrPause.tag = 0;
    [_middleImageTimer setFireDate:[NSDate distantPast]];
    [self.playOrPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [[CYJPlayer sharePlayer].player play];
    
    [[CYJPlayer sharePlayer].player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:(dispatch_get_main_queue()) usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(_playerItem.duration);
        self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
        self.durationTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)totalTime/60,(int)totalTime%60];
        self.musicSlide.value = currentTime/totalTime;
        
    }];
}
- (void)updateFindMusic
{
    [self.middleImage sd_setImageWithURL:[NSURL URLWithString:self.musicListArr[_musicListIndex][@"songphoto"]]];
    self.musicName.text = self.musicListArr[_musicListIndex][@"songname"];
    self.singerName.text = self.musicListArr[_musicListIndex][@"songer"];
    
    self.musicSlide.value = 0;
    self.playOrPause.tag = 0;
    [_middleImageTimer setFireDate:[NSDate distantPast]];
    [self.playOrPause setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [[CYJPlayer sharePlayer].player play];
    
    [[CYJPlayer sharePlayer].player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:(dispatch_get_main_queue()) usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        CGFloat totalTime = CMTimeGetSeconds(_playerItem.duration);
        self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)currentTime/60,(int)currentTime%60];
        self.durationTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)totalTime/60,(int)totalTime%60];
        self.musicSlide.value = currentTime/totalTime;
    }];
}
#pragma mark - musicListTable datasource delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicListArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cyjCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //如果没有取出，创建新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.textLabel.text =  self.musicListArr[indexPath.row][@"songname"];
    cell.detailTextLabel.text = self.musicListArr[indexPath.row][@"songer"];;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //刷新播放界面
    if (self.musicName.text == self.musicListArr[indexPath.row][@"songname"]) {
        [self dismissTheTab];
        return;
    }else
    {
        self.musicListIndex = indexPath.row;
        self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.musicListArr[indexPath.row][@"filename"]]];
        [[CYJPlayer sharePlayer].player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self updateFindMusic];
    }
    [self dismissTheTab];
}


@end
