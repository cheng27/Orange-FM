//
//  CYJListenVC.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJListenVC.h"
#import "Header.h"



@interface CYJListenVC ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *todayImage;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UIImageView *findImage;
@property (weak, nonatomic) IBOutlet UILabel *findLabel;
@property (weak, nonatomic) IBOutlet UIView *picView;


@property (nonatomic,strong) NSMutableArray *scrollImgArr;
@property (nonatomic,strong) NSMutableArray *scrollArr;
@property (nonatomic,strong) NSMutableArray *allListArr;
@end

@implementation CYJListenVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //加载轮播图
    [self requestData2ScrollView];
    //加载今日音乐人数据
    [self todayMusicFromNet];
    //加载最新猎乐者
    [self findMusicFromNet];
}
#pragma mark - 懒加载
//存储scrollView上的图片的数组
- (NSMutableArray *)scrollImgArr
{
    if (_scrollImgArr == nil) {
        _scrollImgArr = [NSMutableArray array];
    }
    return _scrollImgArr;
}
//存储scrollView数据的数组
- (NSMutableArray *)scrollArr
{
    if (_scrollArr == nil) {
        _scrollArr = [NSMutableArray array];
    }
    return _scrollArr;
}
//存储所有数据的数组
- (NSMutableArray *)allListArr
{
    if (_allListArr == nil) {
        _allListArr = [NSMutableArray array];
    }
    return _allListArr;
}

#pragma mark - add subviews
//轮播图
- (void)addScrollView
{
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, _picView.frame.size.width, _picView.frame.size.height) imageNamesGroup:nil];
    cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleView.imageURLStringsGroup = self.scrollImgArr;
    cycleView.pageDotColor = [UIColor whiteColor];
    cycleView.currentPageDotColor = [UIColor orangeColor];
    cycleView.placeholderImage = [UIImage imageNamed:@"bigPlaceHolder"];
    cycleView.delegate = self;
    [self.view addSubview:cycleView];
}

#pragma mark - btn action
//今日更多
- (IBAction)todayMoreAction:(id)sender {
}
//发现更多
- (IBAction)findMoreAction:(id)sender {
}



#pragma mark - scrollView delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ScrollDetailVC *scrollVC = [[ScrollDetailVC alloc] init];
    scrollVC.webUrlString = self.scrollArr[index][@"link"];
    [self.navigationController pushViewController:scrollVC animated:YES];
}
#pragma mark - request from net
//请求轮播图数据
- (void)requestData2ScrollView
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlString = @"http://files.wawa.fm:9090/wawa/api.php/ad/lists/size/4?platform=wwandroid&uid=24114&uid=24114";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@" >>>> response %@",responseObject);
        for (NSDictionary *dict in responseObject) {
            [self.allListArr addObject:dict];
        }
        for (NSDictionary *dict in self.allListArr) {
            [self.scrollImgArr addObject:dict[@"image"]];
            [self.scrollArr addObject:dict];
        }
        [self.allListArr removeAllObjects];
        [self addScrollView];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" >>>> error %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
//请求今日音乐人数据
- (void)todayMusicFromNet
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlString = @"http://wawa.fm/CmsSite/a/cms/article/myrnew?platform=wwandroid&uid=24114";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@" >>> response %@",responseObject);
        for (NSDictionary *dict in responseObject) {
            [self.allListArr addObject:dict];
            [self.todayImage sd_setImageWithURL:[NSURL URLWithString:self.allListArr[0][@"image"]]];
            self.todayLabel.text = self.allListArr[0][@"title"];
        }
        [self.allListArr removeAllObjects];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@" >>> error %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
//请求最新猎乐者数据
- (void)findMusicFromNet
{
    NSString *urlString = @"http://wawa.fm/CmsSite/a/cms/magazine/milist?platform=wwandroid&pageNo=1&uid=24114&pageSize=1";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@" >>> response %@",responseObject);
        for (NSDictionary *dict in responseObject) {
            [self.allListArr addObject:dict];
            [self.findImage sd_setImageWithURL:[NSURL URLWithString:self.allListArr[0][@"mphoto"]]];
            self.findLabel.text = self.allListArr[0][@"mname"];
        }
        [self.allListArr removeAllObjects];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@" >>> error %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}



@end
