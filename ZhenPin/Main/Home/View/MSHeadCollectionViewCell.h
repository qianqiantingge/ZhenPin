//
//  MSHeadCollectionViewCell.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSHeadCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView;

@end
