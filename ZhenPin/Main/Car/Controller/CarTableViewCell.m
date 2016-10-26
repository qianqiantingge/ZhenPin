//
//  CarTableViewCell.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "CarTableViewCell.h"

@implementation CarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
////    CGColorRef colorrref = CGColorCreate(colorSpace, (CGFloat[]){73/255.0,73/255.0,73/255.0,73/255.0,73/255.0});
//    [self.addBtn.layer setBorderColor:colorrref];
//    [self.lIttleBtn.layer setBorderColor:colorrref];
//    [self.countBtn.layer setBorderColor:colorrref];
    [self.lIttleBtn.layer setBorderWidth:1];
    [self.countBtn.layer setBorderWidth:1];
    [self.addBtn.layer setBorderWidth:1];
    _count = 1;
    [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_count] forState:UIControlStateNormal];
    
    
}

- (IBAction)littleBtn:(id)sender {
    if (_count > 0){
        _count --;
        [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_count] forState:UIControlStateNormal];
        if (_count == 0){
             self.lIttleBtn.layer.cornerRadius =  self.lIttleBtn.frame.size.height/2;
        
        }
    }
    
}

- (IBAction)addBtn:(id)sender {
    
     _count ++;
    self.lIttleBtn.layer.cornerRadius = 0;
    [self.countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_count] forState:UIControlStateNormal];
  
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
