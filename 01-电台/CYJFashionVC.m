//
//  CYJFashionVC.m
//  01-电台
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJFashionVC.h"
#import "Header.h"
#import "NewProductsCell.h"

@interface CYJFashionVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIRefreshControl *refresh;
}
@property (weak, nonatomic) IBOutlet UITableView *fashionTable;
@property (nonatomic,strong) NSMutableArray *fashionArr;
@property (nonatomic,assign) NSInteger pageNum;

@end

@implementation CYJFashionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestFashionData];
    self.pageNum = 1;
    [self addRefreshControl];
    // Do any additional setup after loading the view.
}

#pragma mark - 懒加载
- (NSMutableArray *)fashionArr
{
    if (_fashionArr == nil) {
        _fashionArr = [NSMutableArray array];
    }
    return _fashionArr;
}

- (void)addRefreshControl
{
    _fashionTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       // NSLog(@"下拉刷新");
        self.pageNum = 1;
        [self requestFashionData];
    }];
    _fashionTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       // NSLog(@"上拉加载");
        self.pageNum ++;
        [self requestFashionData];
    }];
}
#pragma mark - 网络请求
- (void)requestFashionData
{
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@""];
    NSString *urlString = [NSString stringWithFormat:@"http://www.wezeit.com/index.php?m=Home&c=Api&a=channelList&channel_id=41234&page=%ld&time=1452474550&click_time=0&end_item=0&device_id=866819029961576&version=android_3.3.8",(long)self.pageNum];
    NSMutableArray *muarr = [NSMutableArray array];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"response >>>> %@",responseObject);
        NSArray *array = responseObject[@"datas"][@"list"];
        for (NSDictionary *dict in array) {
            if (_pageNum == 1) {
                [muarr addObject:dict];
            }else
            {
                [self.fashionArr addObject:dict];
            }
        }
        if (_pageNum == 1) {
            self.fashionArr = muarr;
        }
        [_fashionTable reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error >>> %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    if (_fashionTable.mj_header.isRefreshing) {
        [_fashionTable.mj_header endRefreshing];
    }
    if (_fashionTable.mj_footer.isRefreshing) {
        [_fashionTable.mj_footer endRefreshing];
    }
}
#pragma mark - tableView delegate datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fashionArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cyjcell";
    NewProductsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *dict = self.fashionArr[indexPath.row];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewProductsCell" owner:self options:nil][0] ;
    }
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:dict[@"thumbnail"]]placeholderImage:[UIImage imageNamed:@"bigPlaceHolder.png"]];
    cell.titleLabel.text = dict[@"title"];
    cell.fromLabel.text = dict[@"author"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ScrollDetailVC *vc = [[ScrollDetailVC alloc] init];
    vc.webUrlString = self.fashionArr[indexPath.row][@"share"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
