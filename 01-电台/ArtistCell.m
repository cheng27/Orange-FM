//
//  ArtistCell.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "ArtistCell.h"

@implementation ArtistCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.topImage.layer.cornerRadius = 8;
    self.topImage.clipsToBounds = YES;
}

@end
