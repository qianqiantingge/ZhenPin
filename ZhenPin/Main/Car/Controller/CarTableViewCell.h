//
//  CarTableViewCell.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *lIttleBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UILabel *sizeL;
@property (nonatomic,assign) NSInteger count;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;

@end
