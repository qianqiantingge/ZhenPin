//
//  GoodItemBottomView.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GoodItemBottomViewProTocol <NSObject>
-(void)handleButton:(UIButton *)button;
@end

@interface GoodItemBottomView : UIView

+(GoodItemBottomView*)createBottomViewWithDelegate:(id<GoodItemBottomViewProTocol>)dele inView:(UIView*)view;
@property(nonatomic,weak) id<GoodItemBottomViewProTocol> dele;
@property(nonatomic,strong) UILabel *countLabel;
@end
