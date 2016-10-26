//
//  tableViewCell.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "tableViewCell.h"

#import "Common.h"


@implementation tableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    _dataArr = [NSArray array];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CateChildCell" bundle:nil] forCellWithReuseIdentifier:@"CateChildCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//MARK: UICollectionView 协调方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CateChildCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CateChildCell" forIndexPath:indexPath];
    CateChildModel *model = _dataArr[indexPath.item];
    [cell.iconView sd_setImageWithURL: [NSURL URLWithString:model.imageUrl]];
    cell.nameL.text = model.categoryName;

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / 5, SCREEN_WIDTH / 5 + 30);
}

//item的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//委托方第三步：回调
    [self.delegate backIndex:indexPath other:self.indexSection];
}

@end
