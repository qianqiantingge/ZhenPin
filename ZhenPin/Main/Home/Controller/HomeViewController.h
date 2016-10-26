//
//  HomeViewController.h
//  SSTGood
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@protocol HomeCateViewControllerProtocol <NSObject>
-(void)pushVC:(UIViewController*)vc;
@end

@interface HomeViewController : CommonViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong) UITableView *contentTV;
@property(nonatomic,copy) NSString *pageId;
@property(nonatomic,weak) id<HomeCateViewControllerProtocol> dele;
@end
