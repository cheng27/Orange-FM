//
//  CYJFileManager.m
//  01-电台
//
//  Created by qingyun on 16/1/19.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "CYJFileManager.h"
#import "CYJPlayerModel.h"
#import "FMDB.h"
#import "Header.h"

@interface CYJFileManager ()
@property (nonatomic,strong) FMDatabase *db;
@end

@implementation CYJFileManager

+ (instancetype)shareManager
{
    static CYJFileManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CYJFileManager alloc] init];
        [manager createTable];
    });
    return manager;
}
- (NSString *)libraryPath
{
    NSString *dbPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    return dbPath;
}
- (FMDatabase *)db
{
    if (_db) {
        return _db;
    }
    //创建db对象
//    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [[self libraryPath] stringByAppendingPathComponent:kDBFileName];
    _db = [FMDatabase databaseWithPath:filePath];
    return _db;
}

//创建表
- (BOOL)createTable
{
    //1.打开数据库
    if (![self.db open]) {
        return NO;
    }
    //2.执行sql语句
    if (![self.db executeUpdate:@"create table if not exists musics(imageUrl text,musicName text,musicUrl text,musicianName text)"]) {
        NSLog(@" >>>> error %@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
    //关闭数据库
    [self.db close];
    return YES;
}
//插入数据
- (BOOL)insertData:(CYJPlayerModel *)model
{
    if (![self.db open]) {
        return NO;
    }
    if (![self.db executeUpdate:@"insert into musics values(?,?,?,?)",model.imageUrl,model.musicName,model.musicUrl,model.musicianName]) {
        NSLog(@" >>>> error %@",[self.db lastErrorMessage]);
        [self.db close];
        return NO;
    }
    //关闭数据库
    [self.db close];
    return YES;
}
//查询所有数据
- (NSMutableArray *)selectAllData
{
    if (![self.db open]) {
        return nil;
    }
    FMResultSet *set = [self.db executeQuery:@"select * from musics"];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        CYJPlayerModel *model = [[CYJPlayerModel alloc] initWithDict:[set resultDictionary]];
        //[array addObject:[self modelFromResetValue:set]];
        [array addObject:model];
    }
    [self.db close];
    return array;
}
//- (CYJPlayerModel *)modelFromResetValue:(FMResultSet *)set
//{
//    NSString *imageUlr = [set stringForColumn:@"imageUrl"];
//    NSString *musicName = [set stringForColumn:@"musicName"];
//    NSString *musicUrl = [set stringForColumn:@"musicUrl"];
//    NSString *musicianName = [set stringForColumn:@"musicianName"];
//    return [CYJPlayerModel initWithImageUrl:imageUlr withMusicName:musicName withMusicUrl:musicUrl andMusicianName:musicianName];
//}


@end










