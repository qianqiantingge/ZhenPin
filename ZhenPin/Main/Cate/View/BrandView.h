//
//  BrandView.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Common.h"
#import "MJRefresh.h"
#import "BrandModel.h"

//委托方第一步：声明协议
@protocol BrandViewDelegate <NSObject>

- (void)backIndex: (NSInteger)index;

@end

@interface BrandView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * allBtn;
@property (nonatomic, strong) NSMutableArray * brandArray;

//委托方第二步：代理指针
@property (nonatomic, weak) id <BrandViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame array: (NSArray *)array;


@end
