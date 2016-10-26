//
//  SSTGDScrollView.h
//  SSTNews
//
//  Created by qianfeng on 16/8/29.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSTGDScrollViewDelegate <NSObject>

-(void)handleTap:(UIImageView*)imageV;

@optional
-(void)endScroll;

@end



@interface SSTGDScrollView : UIScrollView<UIScrollViewDelegate>{
}


@property(nonatomic,assign) int currentIndex;
@property(nonatomic,weak) id<SSTGDScrollViewDelegate> svDelegate;

+(instancetype)scrollViewWithFrame:(CGRect)frame imgArr:(NSArray*)imgArray titleArr:(NSArray*)titleArr time:(NSTimeInterval)timeT imgPick:(BOOL)isImgPick;

@end
