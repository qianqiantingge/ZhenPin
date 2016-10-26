//
//  MyCell.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    

    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.cornerRadius = self.iconView.mj_h / 8;
    
    self.clipsToBounds = YES;
    
}

@end
