//
//  CYJReaderVC.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJReaderVC.h"
#import "Header.h"
#import "NewProductsCell.h"
#import "ArtistCell.h"


@interface CYJReaderVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIRefreshControl *refresh;
}
//分段控制器
@property (nonatomic,strong) UISegmentedControl *titleSegment;
@property (nonatomic,strong) UIScrollView *scrollView;
//新品
@property (nonatomic , assign)NSInteger xinPageNo;
@property (nonatomic , retain)UITableView *xinProductView;
@property (nonatomic , retain)NSMutableArray *xinProductArray;
//艺文
@property (nonatomic , assign)NSInteger artistPageNo;
@property (nonatomic , retain)UICollectionViewFlowLayout *flowLayout;//布局
@property (nonatomic , retain)UICollectionView *artistView;
@property (nonatomic , retain)NSMutableArray *artistArray;
//有品
@property (nonatomic,strong) UICollectionView *admireView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout1;
@property (nonatomic,assign) NSInteger admirePageNo;
@property (nonatomic,strong) NSMutableArray *admireArray;
//应用
@property (nonatomic,strong) UITableView *appTableView;
@property (nonatomic,strong) NSMutableArray *appArray;
@property (nonatomic,assign) NSInteger appPageNo;

@end

@implementation CYJReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xinPageNo = 1;
    self.artistPageNo = 1;
    self.admirePageNo = 1;
    self.appPageNo = 1;
    self.view.backgroundColor = [UIColor colorWithRed:248 /255.0 green:246/ 255.0 blue:232 / 255.0 alpha:1];
    [self.view addSubview:self.titleSegment];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.xinProductView];
    [self.scrollView addSubview:self.artistView];
    [self.scrollView addSubview:self.admireView];
    [self.scrollView addSubview:self.appTableView];
    //加载新品欣赏
    [self loadNewProductsFromNet];
    //加载精选艺文
    [self loadArtistFromNet];
    //加载有品
    [self loadAdmireFromNet];
    //加载应用
    [self loadAppFromNet];
}
#pragma mark - 懒加载
//新品数组
- (NSMutableArray *)xinProductArray
{
    if (_xinProductArray == nil) {
        _xinProductArray = [NSMutableArray array];
    }
    return _xinProductArray;
}
//艺文数组
- (NSMutableArray *)artistArray
{
    if (_artistArray == nil) {
        _artistArray = [NSMutableArray array];
    }
    return _artistArray;
}
//有品数组
- (NSMutableArray *)admireArray
{
    if (_admireArray == nil) {
        _admireArray = [NSMutableArray array];
    }
    return _admireArray;
}
- (NSMutableArray *)appArray
{
    if (_appArray == nil) {
        _appArray = [NSMutableArray array];
    }
    return _appArray;
}


//分段控制器
- (UISegmentedControl *)titleSegment
{
    if (_titleSegment == nil) {
        _titleSegment = [[UISegmentedControl alloc] initWithItems:@[@"艺文",@"新品",@"有品",@"应用"]];
        _titleSegment.frame = CGRectMake(kSpace/2, 64, kScreenWidth - 10, 30) ;
        _titleSegment.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.000];
        _titleSegment.selectedSegmentIndex = 0;
        //为这个UISegmentedControl 添加监听方法 他继承与 UIControl 可以监听方法这样就可以观察他的Value的值的改变进行事件的改变
        [_titleSegment addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    }
    return _titleSegment;
}
- (void)changeView:(UISegmentedControl *)segmentedControl
{
    
    [self.scrollView setContentOffset:CGPointMake(segmentedControl.selectedSegmentIndex * kScreenWidth, 0) animated:YES];
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kSpace * 9, kScreenWidth , kScreenHeight - kSpace*5)];
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 4, kScreenHeight) ;
        _scrollView.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
        
        _scrollView.scrollEnabled = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}


//新品tableview
- (UITableView *)xinProductView
{
    if (_xinProductView == nil) {
        _xinProductView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kSpace * 14) style:UITableViewStylePlain];
        _xinProductView.dataSource = self;
        _xinProductView.delegate = self;
        _xinProductView.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
        __block CYJReaderVC *blockSelf = self;
        _xinProductView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            blockSelf.xinPageNo ++;
            [blockSelf loadNewProductsFromNet];;
        }];
        _xinProductView.tableFooterView = [[UIView alloc]init];
    }
    return _xinProductView;
}
//应用tableView
- (UITableView *)appTableView
{
    if (_appTableView == nil) {
        _appTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth * 3, 0, kScreenWidth, kScreenHeight - kSpace * 14) style:UITableViewStylePlain];
        _appTableView.dataSource = self;
        _appTableView.delegate = self;
        _appTableView.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
        __block CYJReaderVC *blockSelf = self;
        _appTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            blockSelf.appPageNo ++;
            [blockSelf loadAppFromNet];

        }];
        _appTableView.tableFooterView = [[UIView alloc]init];
    }
    return _appTableView;
}

/*
 * ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️如果在同一个VC上添加了两个collectionView，在使用reloadData更新视图的时候，如果数据源多于更新之前的数据的个数时，就有可能出现Assertion failure in -[UICollectionViewData validateLayoutInRect:]错误，解决的办法就是：千万不要使用同一个flowLayout!!!
 *
 */
- (UICollectionViewFlowLayout *)flowLayout
{
    if(_flowLayout == nil)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = kMark;
    }
    return _flowLayout;
}
- (UICollectionViewFlowLayout *)flowLayout1
{
    if(_flowLayout1 == nil)
    {
        _flowLayout1 = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout1.minimumInteritemSpacing = 0;
        _flowLayout1.minimumLineSpacing = kMark;
    }
    return _flowLayout1;
}
//艺文collectionView
-(UICollectionView *)artistView{
    if (_artistView == nil) {
        _artistView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth , kScreenHeight - kSpace * 14) collectionViewLayout:self.flowLayout];
        _artistView.delegate = self;
        _artistView.dataSource = self;
        _artistView.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
        [_artistView registerNib:[UINib nibWithNibName:@"ArtistCell" bundle:nil] forCellWithReuseIdentifier:@"artistitem"];
        __block CYJReaderVC *blockSelf = self;
        _artistView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            blockSelf.artistPageNo ++;
            [blockSelf loadArtistFromNet];;
        }];
        
    }
    return _artistView;
}

//有品collectionView
- (UICollectionView *)admireView
{
    if (_admireView == nil) {
        _admireView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - kSpace * 14) collectionViewLayout:self.flowLayout1];
        _admireView.delegate = self;
        _admireView.dataSource = self;
        _admireView.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
        [_admireView registerNib:[UINib nibWithNibName:@"ArtistCell" bundle:nil] forCellWithReuseIdentifier:@"artistitem"];
        __block CYJReaderVC *blockSelf = self;
        _admireView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            blockSelf.admirePageNo ++;
            [blockSelf loadAdmireFromNet];
        }];
    }
    return _admireView;
}



#pragma mark - xinTableView  delegate datasource
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.xinProductView]) {
        return self.xinProductArray.count;
    }
    if ([tableView isEqual:self.appTableView]) {
        return self.appArray.count;
    }
    return 0;
    
}
//设置行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cyjCell";
    NewProductsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NewProductsCell" owner:self options:nil][0] ;
    }
    if ([tableView isEqual:self.xinProductView]) {
        NSDictionary *dict = self.xinProductArray[indexPath.row];
        [cell.backImage sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"bigPlaceHolder.png"]];
        cell.titleLabel.text = dict[@"title"];
        cell.fromLabel.text = [NSString stringWithFormat:@"来自于:%@",dict[@"createBy"][@"nickname"]];
    }
    if ([tableView isEqual:self.appTableView]) {
        NSDictionary *dict = self.appArray[indexPath.row];
        [cell.backImage sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"bigPlaceHolder.png"]];
        cell.titleLabel.text = dict[@"title"];
        cell.fromLabel.text = [NSString stringWithFormat:@"来自于:%@",dict[@"createBy"][@"nickname"]];
    }
    
    return cell;
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
//设置每行的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollDetailVC *vc = [[ScrollDetailVC alloc]init];
    if ([tableView isEqual:self.xinProductView]) {
        vc.webUrlString = self.xinProductArray[indexPath.row][@"articleUrl"];
    }
    if ([tableView isEqual:self.appTableView]) {
        vc.webUrlString = self.appArray[indexPath.row][@"articleUrl"];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
//设置将要显示的行的动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = CATransform3DMakeTranslation(0.1, 0.1, 1);
    cell.layer.transform = CATransform3DInvert(rotation);
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:1.2];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}


#pragma mark - collectionView delegate datasource
//设置组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//设置item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_artistView]) {
        return self.artistArray.count;
    }
    
    if ([collectionView isEqual:_admireView]) {
        return  self.admireArray.count;
    }
    return 0;
    
}
//设置item的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArtistCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"artistitem" forIndexPath:indexPath];
    
    if ([collectionView isEqual:_artistView]) {
        cell.contentLabel.text = self.artistArray[indexPath.item][@"title"];
        cell.fromLabel.text = self.artistArray[indexPath.item][@"createBy"][@"nickname"];
        NSString *imageUrl = self.artistArray[indexPath.item][@"image"];
        [cell.topImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    if ([collectionView isEqual:_admireView]) {
        cell.contentLabel.text = self.admireArray[indexPath.item][@"title"];
        cell.fromLabel.text = self.admireArray[indexPath.item][@"createBy"][@"nickname"];
        NSString *imageUrl = self.admireArray[indexPath.item][@"image"];
        [cell.topImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 3*kMark) / 2.f , 200);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kSpace, kMark, kSpace, kMark);
}
//设置每一个item的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollDetailVC *vc = [[ScrollDetailVC alloc]init];
    if ([collectionView isEqual:self.artistView]) {
        vc.webUrlString = self.artistArray[indexPath.item][@"articleUrl"];
    }
    if ([collectionView isEqual:self.admireView]) {
        vc.webUrlString = self.admireArray[indexPath.item][@"articleUrl"];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 网络请求
//加载新品欣赏
- (void)loadNewProductsFromNet
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlStr = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/article/mylist?category.id=28&pageNo=%ld&pageSize=10&uid=0&callback=data&_=1452915260492",(long)self.xinPageNo];
    ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str1 = [string substringFromIndex:5];
        NSString *str2 = [str1 substringToIndex:str1.length - 1];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in arr) {
            [self.xinProductArray addObject:dict];
        }
       // NSLog(@" >>> %@",self.xinProductArray);
        [self.xinProductView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>> %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    //停止加载
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    
    if (self.xinProductView.mj_footer.isRefreshing) {
        [self.xinProductView.mj_footer endRefreshing];
    }

}
//加载应用数据
- (void)loadAppFromNet
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlStr = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/article/mylist?category.id=30&pageNo=%ld&pageSize=10&uid=0&callback=data&_=1452915399005",(long)self.appPageNo];
    ;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str1 = [string substringFromIndex:5];
        NSString *str2 = [str1 substringToIndex:str1.length - 1];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in arr) {
            [self.appArray addObject:dict];
        }
         //NSLog(@" >>> %@",self.appArray);
        [self.appTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>> %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    //停止加载
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    
    if (self.appTableView.mj_footer.isRefreshing) {
        [self.appTableView.mj_footer endRefreshing];
    }

}



//加载精选艺文
- (void)loadArtistFromNet
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlStr = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/article/mylist?category.id=29&pageNo=%ld&pageSize=10&uid=24114&callback=data",(long)self.artistPageNo];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str1 = [string substringFromIndex:5];
        NSString *str2 = [str1 substringToIndex:str1.length - 1];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in arr) {
            [self.artistArray addObject:dict];
        }
        [self.artistView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>> %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    //停止加载
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    
    if (self.artistView.mj_footer.isRefreshing) {
        [self.artistView.mj_footer endRefreshing];
    }
}
//加载有品数据
- (void)loadAdmireFromNet
{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlStr = [NSString stringWithFormat:@"http://wawa.fm/CmsSite/a/cms/article/mylist?category.id=650&pageNo=%ld&pageSize=10&uid=0&callback=data&_=1452915578542",(long)self.admirePageNo];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *str1 = [string substringFromIndex:5];
        NSString *str2 = [str1 substringToIndex:str1.length - 1];
        NSData *data = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *dict in arr) {
            [self.admireArray addObject:dict];
        }
        //NSLog(@" >>>> %@",self.admireArray);
        [self.admireView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@">>>>> %@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加载失败哦..." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    //停止加载
    if (refresh.isRefreshing) {
        [refresh endRefreshing];
    }
    if (self.admireView.mj_footer.isRefreshing) {
        [self.admireView.mj_footer endRefreshing];
    }
}

@end
