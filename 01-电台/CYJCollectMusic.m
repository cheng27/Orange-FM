//
//  CYJCollectMusic.m
//  01-电台
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJCollectMusic.h"
#import "MusicCell.h"
#import "Header.h"
#import "CYJFileManager.h"

@interface CYJCollectMusic ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *musicList;
@property (nonatomic,strong) NSMutableArray *musicArr;

@end

@implementation CYJCollectMusic

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _musicList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _musicList.dataSource = self;
    _musicList.delegate = self;
    _musicList.backgroundColor = [UIColor colorWithRed:248 /255.   green:246 / 255. blue:232 / 255. alpha:1.000];
    _musicArr = [[CYJFileManager shareManager] selectAllData];
    [self.view addSubview:_musicList];
    // Do any additional setup after loading the view.
}


#pragma mark - tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _musicArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:self options:nil][0];
    }
    
    //_musicArr = [[CYJFileManager shareManager] selectAllData];
    NSDictionary *dict = _musicArr[indexPath.row];
    [cell.musicImage sd_setImageWithURL:[NSURL URLWithString:dict[@"imageUrl"]]];
    cell.musicName.text = dict[@"musicName"];
    cell.singer.text = dict[@"musicianName"];
    [_musicList reloadData];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
