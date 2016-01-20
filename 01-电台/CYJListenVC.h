//
//  CYJListenVC.h
//  01-电台
//
//  Created by qingyun on 16/1/11.
//  Copyright © 2016年 阿六. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYJListenVC;

@protocol CYJListenVCDelegate <NSObject>

- (void)collectionCell:(CYJListenVC *)collectionCell passValue:(NSString *)string;

@end


@interface CYJListenVC : UIViewController
@property (nonatomic,strong) id <CYJListenVCDelegate> delegate;

@end
