//
//  HomeTableViewCell.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Common.h"
#import "GoodItemCollectionViewCell.h"
#import "HomeModel.h"
#import "UIImageView+WebCache.h"
#import "ADViewController.h"
#import "GoodItemViewController.h"

@interface HomeTableViewCell()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@end


@implementation HomeTableViewCell

-(void)setDataArr:(NSArray *)dataArr{

    _dataArr=dataArr;
    [_colV reloadData];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_bgView.layer setCornerRadius:5.0];
    [_bgView.layer setMasksToBounds:true];
    [_titleLabel setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.5]];
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing:gap*1.5];
    [layout setMinimumInteritemSpacing:gap*1.5];
    //
    [_colV setBackgroundColor:[UIColor clearColor]];
    [_colV setShowsHorizontalScrollIndicator:false];
    [_colV setCollectionViewLayout:layout];
    [_colV registerNib:[UINib nibWithNibName:@"GoodItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodItemCollectionViewCell"];
    _colV.delegate=self;
    _colV.dataSource=self;
    
    [_bgView setUserInteractionEnabled:true];
    [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count-1;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 150);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodItemCollectionViewCell" forIndexPath:indexPath];
    ItemModel *itemM=(ItemModel*)_dataArr[indexPath.row+1];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:itemM.productImage]];
    [cell.titleLabel setText:itemM.customname];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%@",itemM.marketPrice]];
    [cell.oldPriceLabel setText:[NSString stringWithFormat:@"￥%@",itemM.activityPrice]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodItemViewController *goodItemC=[[GoodItemViewController alloc]init];
    [goodItemC setProductId:((ItemModel*)_dataArr[indexPath.row+1]).productId];
    [self.dele pushVC:goodItemC];
}

-(void)handleTap:(UITapGestureRecognizer*)tapG{

    ADViewController *adVC=[[ADViewController alloc]init];
    adVC.titl=_ti;
    adVC.url=_imgUrl;
    [self.dele pushVC:adVC];
}
@end
