//
//  MusicCell.m
//  01-电台
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
    self.musicImage.layer.cornerRadius = 75;
    self.musicImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
