//
//  CYJFileManager.h
//  01-电台
//
//  Created by qingyun on 16/1/19.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYJPlayerModel;

@interface CYJFileManager : NSObject

+ (instancetype)shareManager;
//插入数据
- (BOOL)insertData:(CYJPlayerModel *)model;

- (NSMutableArray *)selectAllData;
@end
