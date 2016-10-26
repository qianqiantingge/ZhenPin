//
//  HomeTableViewCell.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImgV;
@property (weak, nonatomic) IBOutlet UIImageView *smallImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *colV;

@property(nonatomic,strong) NSArray *dataArr;
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,copy) NSString *ti;

@property(nonatomic,weak) id<HomeCateViewControllerProtocol> dele;
@end
