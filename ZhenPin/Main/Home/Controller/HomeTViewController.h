//
//  HomeTViewController.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface HomeTViewController : UIViewController

@property(nonatomic,strong) UITableView *contentTV;
@property(nonatomic,copy) NSString *pageId;
@property(nonatomic,weak) id<HomeCateViewControllerProtocol> dele;
@end
