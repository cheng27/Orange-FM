//
//  CYJTodayMusicVC.m
//  01-电台
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJTodayMusicVC.h"
#import "Header.h"
#import "TodayMusicCell.h"
#import "CYJTodayMusicDetailVC.h"

@interface CYJTodayMusicVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIRefreshControl *refresh;
}
@property (weak, nonatomic) IBOutlet UITableView *todayMusicTable;
@property (nonatomic,strong) NSMutableArray *todayMusicArray;
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation CYJTodayMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNum = 1;
    [self addRefreshControl];
    [self requestTodayMusic];
}
#pragma mark - 懒加载
- (NSMutableArray *)todayMusicArray
{
    if (_todayMusicArray == nil) {
        _todayMusicArray = [NSMutableArray array];
    }
    return _todayMusicArray;
}
#pragma mark - 添加自定义的子视图
- (void)addRefreshControl
{
    _todayMusicTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新执行的操作
        self.pageNum = 1;
        if (self.todayMusicArray.count != 0) {
            [self.todayMusicArray removeAllObjects];
        }
        [self requestTodayMusic];
    }];
    _todayMusicTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载执行的操作
        self.pageNum ++;
        [self requestTodayMusic];
    }];
}
#pragma mark - 网络请求
- (void)requestTodayMusic
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlString = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/article/mylist?category.id=543&pageNo=%ld&pageSize=10&uid=24114&callback=data",(long)self.pageNum];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str1 = [string substringFromIndex:5];
        NSString *str2 = [str1 substringToIndex:str1.length - 1];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in arr) {
            [self.todayMusicArray addObject:dict];
            //NSLog(@" >>> arr %@",self.todayMusicArray);
        }
        [self.todayMusicTable reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@" >>> error %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    if (self.todayMusicTable.mj_header.isRefreshing) {
        [self.todayMusicTable.mj_header endRefreshing];
    }
    if (self.todayMusicTable.mj_footer.isRefreshing) {
        [self.todayMusicTable.mj_footer endRefreshing];
    }
}
#pragma mark - tableView dataSource delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todayMusicArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cyjCell";
    TodayMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TodayMusicCell" owner:self options:nil][0];
    }
    NSDictionary *dict = self.todayMusicArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"bigPlaceHolder.png"]];
    cell.musicName.text = dict[@"articleData"][@"songname"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CYJTodayMusicDetailVC *todayMusicDetail = [[CYJTodayMusicDetailVC alloc] init];
    todayMusicDetail.musicDetailID = self.todayMusicArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:todayMusicDetail animated:YES];
}

@end
