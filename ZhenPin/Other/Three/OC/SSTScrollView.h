//
//  SSTScrollView.h
//  SSTNews
//
//  Created by qianfeng on 16/8/29.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTGDScrollView.h"

// 3种style
typedef enum{
    MyScrollViewStyleLabel,      // 右下角显示label  当前页/所有页      （默认）
    MyScrollViewStyleButton,     // 左右两边button   前一页、后一页
    MyScrollViewStylePageC,      // 下部显示pageControl
    MyScrollViewStyleDownLabel,  // 下方显示图片简介
    MyScrollViewStyleImgPick,    // 图片查看器
}MyScrollViewStyle;




@interface SSTScrollView : UIView<SSTGDScrollViewDelegate>

@property(nonatomic,weak) id<SSTGDScrollViewDelegate> dele;
+(instancetype)scrollViewWithFrame:(CGRect)frame style:(MyScrollViewStyle)style imgArray:(NSArray*)imgArray titleArr:(NSArray*)titleArr timer:(NSTimeInterval)time;
+(void)imgPickInView:(UIView*)view withURLArr:(NSArray*)urlArr;
@end
