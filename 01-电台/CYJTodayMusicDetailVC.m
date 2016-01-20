//
//  CYJTodayMusicDetailVC.m
//  01-电台
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJTodayMusicDetailVC.h"
#import "Header.h"
#import "DXAlertView.h"

@interface CYJTodayMusicDetailVC ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;
@property (nonatomic,copy) NSString *webUrlString;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *musicName;
@property (nonatomic,strong) UILabel *musicListenTime;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,strong) UIImageView *playBtnIcon;
@property (nonatomic,strong) UIImageView *playBtnBackGround;
@property (nonatomic,strong) NSDictionary *todayMusicDic;

@end

@implementation CYJTodayMusicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestMusic];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.activityView];
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.musicName];
    [self.topView addSubview:self.musicListenTime];
    [self.topView addSubview:self.playBtnBackGround];
    [self.topView addSubview:self.playBtn];
    [self.playBtnBackGround addSubview:self.playBtnIcon];
    
    _webUrlString = [NSString stringWithFormat:@"http://wawa.fm//CmsSite/f/mview-543-%@.html",_musicDetailID];
    [self loadWebPageWithString:self.webUrlString];
}
#pragma mark - 懒加载
- (NSDictionary *)todayMusicDic
{
    if (_todayMusicDic == nil) {
        _todayMusicDic = [NSDictionary dictionary];
    }
    return _todayMusicDic;
}
//webView
- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}
//风火轮
- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] init];
        //设置风火轮显示位置
        [_activityView setCenter:self.view.center];
        //设置风火轮显示样式
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 64, self.view.width, 64);
        self.topView.backgroundColor = [UIColor colorWithRed:120/255. green:200/255. blue:255/255. alpha:1.];
    }
    return _topView;
}
- (UILabel *)musicName
{
    if (_musicName == nil) {
        _musicName = [[UILabel alloc] init];
        _musicName.frame = CGRectMake(15, 5, self.topView.width/3*2, 30);
        _musicName.textColor = [UIColor whiteColor];
    }
    return _musicName;
}
- (UILabel *)musicListenTime
{
    if (_musicListenTime == nil) {
        _musicListenTime = [[UILabel alloc] init];
        _musicListenTime.frame = CGRectMake(15, CGRectGetMaxY(self.musicName.frame), self.musicName.width, 25);
        _musicListenTime.font = [UIFont systemFontOfSize:12];
        _musicListenTime.textColor = [UIColor whiteColor];
    }
    return _musicListenTime;
}
- (UIImageView *)playBtnIcon
{
    if (_playBtnIcon == nil) {
        _playBtnIcon = [[UIImageView alloc] init];
        _playBtnIcon.frame = CGRectMake(self.playBtnBackGround.width/3, self.playBtnBackGround.height/3, self.playBtnBackGround.width/3, self.playBtnBackGround.height/3);
        _playBtnIcon.image = [UIImage imageNamed:@"cell播放"];
        _playBtnIcon.alpha = 0.8;
    }
    return _playBtnIcon;
}
- (UIButton *)playBtn
{
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(CGRectGetWidth(self.topView.frame)-self.topView.width/6, 5, self.topView.width/7, self.topView.width/7);
        _playBtn.backgroundColor = [UIColor clearColor];
        [self.playBtn addTarget:self action:@selector(giveMusicToPlayer:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIImageView *)playBtnBackGround
{
    if (_playBtnBackGround == nil) {
        _playBtnBackGround = [[UIImageView alloc] init];
        _playBtnBackGround.frame = CGRectMake(CGRectGetWidth(self.topView.frame)-self.topView.width/6, 5, self.topView.width/7, self.topView.width/7);
        _playBtnBackGround.backgroundColor = [UIColor colorWithRed:120/255. green:200/255. blue:255/255. alpha:1.];
        _playBtnBackGround.layer.cornerRadius = self.topView.width/14;
        _playBtnBackGround.layer.masksToBounds = YES;
    }
    return _playBtnBackGround;
}
- (void)giveMusicToPlayer:(UIButton *)btn
{
    if (self.todayMusicDic.count != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"todayMusicDic" object:self userInfo:@{@"musicData":self.todayMusicDic}];
    }
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"开始播放音乐" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alert show];
}
- (void)loadWebPageWithString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
#pragma mark - webView delegate
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityView startAnimating];
}
//进行加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
//加载结束
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - 网络请求
- (void)requestMusic
{
    NSString *urlStr = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/article/findByIdlls?type=y&ids=%@&uid=24114&platform=wwandroid&deviceid=00000000-08b5-ffa6-1bb0-43e662cce401&code=N",_musicDetailID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str1 = [string substringFromIndex:5];
        NSString *str2 = [str1 substringToIndex:str1.length - 1];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *dict1 = arr[0][@"articleData"][@"resource"];
        NSDictionary *dict2 = arr[0][@"articleData"];
        
        self.todayMusicDic = dict1;
        self.musicName.text = [NSString stringWithFormat:@"推荐歌曲:%@",self.todayMusicDic[@"songname"]];
        self.musicListenTime.text = [NSString stringWithFormat:@"%@人听过",dict2[@"bfnum"]];
        [self.playBtnBackGround sd_setImageWithURL:[NSURL URLWithString:self.todayMusicDic[@"songphoto"]]];
        
        //NSLog(@"arr >>>> %@",arr );
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"error >>> %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


@end
