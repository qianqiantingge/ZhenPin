//
//  DescriptionCell.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPrice;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@end
