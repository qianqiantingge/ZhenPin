//
//  tableViewCell.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CateChildCell.h"
#import "CateChildModel.h"
#import "UIImageView+WebCache.h"

//委托方第一步：遵守协议
@protocol TableViewDelegate <NSObject>

- (void)backIndex: (NSIndexPath *)indexPath other: (NSInteger)indexPathSection;

@end

@interface tableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArr;

//委托方第二步：代理指针
@property (nonatomic, weak) id <TableViewDelegate> delegate;

@property (nonatomic, assign) NSInteger indexSection;

@end
