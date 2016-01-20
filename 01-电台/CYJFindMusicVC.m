//
//  CYJFindMusicVC.m
//  01-电台
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJFindMusicVC.h"
#import "Header.h"
#import "FindMusicCell.h"

@interface CYJFindMusicVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UIRefreshControl *refresh;
}
@property (nonatomic ,assign)NSInteger pageNo;
@property(nonatomic ,retain)NSMutableDictionary *selectedIndexes;
@property(nonatomic ,retain)NSMutableArray *cellDataArray;
@property(nonatomic ,retain)NSMutableArray *musicArray;
@property (weak, nonatomic) IBOutlet UITableView *findMusicTable;

@end

@implementation CYJFindMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestFindMusic];
    self.pageNo = 1;
    [self addRefreshControl];
    
    
}
#pragma mark - 懒加载
-(NSMutableArray *)musicArray{
    if (_musicArray == nil) {
        self.musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

-(NSMutableArray *)cellDataArray{
    if (_cellDataArray == nil) {
        self.cellDataArray = [NSMutableArray array];
    }
    return _cellDataArray;
}

#pragma mark - 添加自定义的子视图
- (void)addRefreshControl
{
    _findMusicTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新执行的操作
        self.pageNo = 1;
        
        [self requestFindMusic];
    }];
    _findMusicTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //上拉加载执行的操作
        self.pageNo ++;
        [self requestFindMusic];
    }];
}
#pragma mark - 网络请求
- (void) requestFindMusic
{
    [SVProgressHUD showWithStatus:@"正在加载中"];
    NSString *urlString = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/magazine/milist?platform=wwandroid&pageNo=%ld&uid=24114&pageSize=15",(long)self.pageNo];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *muarr = [NSMutableArray array];
       // NSLog(@"response >>> %@",responseObject);
        for (NSDictionary *dict in responseObject) {
            //判断当时是不是在第一页，如果是就用一个单独的数组把第一页的数据保存下来
            if (_pageNo == 1) {
                [muarr addObject:dict];
            }else
            {//如果不是就在原来的数组上追加数据
               [self.cellDataArray addObject:dict];
            }
        }
        if (_pageNo == 1) {
            self.cellDataArray = muarr;
        }
        [_findMusicTable reloadData];
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
    if (_findMusicTable.mj_header.isRefreshing) {
        [_findMusicTable.mj_header endRefreshing];
    }
    if (_findMusicTable.mj_footer.isRefreshing) {
        [_findMusicTable.mj_footer endRefreshing];
    }
}
#pragma mark - btn action
- (void)playBtnAction:(UIButton *)sender
{
    NSMutableArray *array = [NSMutableArray array];
    array = self.cellDataArray[sender.tag - 1000][@"list"];
    if (array.count != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"findMusicList" object:self userInfo:@{@"findMusic":array}];
    }
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"开始播放音乐" leftButtonTitle:nil rightButtonTitle:@"确定"];
    [alert show];

}
#pragma mark - tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self cellIsSelected:indexPath]) {
        return 600;
    }
    return 253;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cyjCell";
    FindMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FindMusicCell" owner:self options:nil][0];
    }
    NSDictionary *dict = self.cellDataArray[indexPath.row];
    cell.musicList.text = dict[@"mname"];
    cell.timeAndNumber.text = [NSString stringWithFormat:@"-第%@期  %@人听过-",dict[@"mnum"],dict[@"hist"]];
    [cell.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:dict[@"mphoto"]]];
    
    cell.playBtn.tag = indexPath.row + 1000;
    
    return cell;
}
- (BOOL)cellIsSelected:(NSIndexPath *)indexPath
{
    NSNumber *selectedIndex = [self.selectedIndexes objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isSelected = ![self cellIsSelected:indexPath];
    
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [self.selectedIndexes setObject:selectedIndex forKey:indexPath];
    
    [_findMusicTable beginUpdates];
    [_findMusicTable endUpdates];
}


@end
