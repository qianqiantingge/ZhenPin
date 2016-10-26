//
//  CarViewController.h
//  SSTGoods
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "Common.h"
#import "CarTableViewCell.h"
#import "CarViewController.h"

@interface CarViewController : UIViewController
- (void)itemHandle:(UIBarButtonItem *)item;
@property UITableView *tableView;
@property UIView *viewHidden;
@property UIView *viewTab;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteRowsAtIndexPaths1:(NSArray *)indexPathsArray;
@property UIButton *selectAllBtn;
@end