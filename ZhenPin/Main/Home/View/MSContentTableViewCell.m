//
//  MSContentTableViewCell.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "MSContentTableViewCell.h"

@implementation MSContentTableViewCell

- (IBAction)buy:(id)sender {
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    [_photoImgV.layer setBorderWidth:1.1];
    [_photoImgV.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    //
    [_countLabel setBackgroundColor:[UIColor colorWithRed:200/255.0 green:80/255.0 blue:80/255.0 alpha:1]];
    [_countLabel.layer setCornerRadius:8.0];
    [_countLabel.layer setMasksToBounds:true];
    [_countLabel setTextColor:[UIColor whiteColor]];
    
    //
    [_buyButton.layer setCornerRadius:8.0];
    [_buyButton.layer setMasksToBounds:true];
    [_buyButton.layer setBorderColor:[UIColor colorWithRed:200/255.0 green:80/255.0 blue:80/255.0 alpha:1].CGColor];
    [_buyButton.layer setBorderWidth:1.1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
