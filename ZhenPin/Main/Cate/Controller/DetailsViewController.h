//
//  DetailsViewController.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseRequest.h"
#import "Common.h"
#import "DescriptionModel.h"
#import "DescriptionCell.h"
#import "DescriptionModel+NetWorkManager.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "SelectedView.h"
#import "ColorModel.h"
#import "PricIntervalModel.h"
#import "BrandView.h"
#import "HDManager.h"
#import "SearchViewController.h"
#import "GoodItemViewController.h"
#import "UserModel.h"
#import "LoginViewController.h"

@interface DetailsViewController : UIViewController

@property (nonatomic, copy) NSString * titleName;
@property (nonatomic, copy) NSString * baseID;
@property (nonatomic, copy) NSString * gender;

@property (nonatomic, copy) NSString * url;

@end
