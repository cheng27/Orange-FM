//
//  FindMusicCell.m
//  01-电台
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "FindMusicCell.h"

@implementation FindMusicCell

- (void)awakeFromNib {
    // Initialization code
    self.playBtn.layer.cornerRadius = 22.5;
    self.playBtn.layer.masksToBounds = YES;
    self.backImage.layer.cornerRadius = 8;
    self.backImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
