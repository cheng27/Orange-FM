//
//  FindMusicCell.h
//  01-电台
//
//  Created by qingyun on 16/1/17.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindMusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *musicList;
@property (weak, nonatomic) IBOutlet UILabel *timeAndNumber;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end
