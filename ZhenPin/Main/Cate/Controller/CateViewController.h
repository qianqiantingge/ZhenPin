//
//  CateViewController.h
//  SSTGood
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonViewController.h"
#import "CateModel.h"
#import "CateChildModel.h"
#import "tableViewCell.h"
#import "BaseRequest.h"
#import "Common.h"
#import "SearchViewController.h"
#import "DetailsViewController.h"
#import "HDManager.h"

@interface CateViewController : CommonViewController{
    UIScrollView * scrollView;
    UIButton * selectedBtn;
}



@end
