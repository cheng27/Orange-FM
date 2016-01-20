//
//  TodayMusicCell.m
//  01-电台
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "TodayMusicCell.h"

@implementation TodayMusicCell

- (void)awakeFromNib {
    // Initialization code
    self.imgView.layer.cornerRadius = 10;
    self.imgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
