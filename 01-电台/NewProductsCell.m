//
//  NewProductsCell.m
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import "NewProductsCell.h"

@implementation NewProductsCell

- (void)awakeFromNib {
    // Initialization code
    self.backImage.layer.cornerRadius = 10;
    self.backImage.clipsToBounds = YES;

    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.shadowColor = [UIColor lightGrayColor];
    self.titleLabel.shadowOffset = CGSizeMake(2, 2);
    self.titleLabel.numberOfLines = 0;
    
    self.fromLabel.font = [UIFont systemFontOfSize:16];
    self.fromLabel.textColor = [UIColor whiteColor];
    self.fromLabel.shadowColor = [UIColor grayColor];
    self.fromLabel.shadowOffset = CGSizeMake(1, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
