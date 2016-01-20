//
//  MusicCell.h
//  01-电台
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *singer;


@end
