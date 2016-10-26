//
//  SSTScrollView.m
//  SSTNews
//
//  Created by qianfeng on 16/8/29.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "SSTScrollView.h"
#import "SSTGDScrollView.h"
#import "Common.h"


@interface SSTScrollView(){

    SSTGDScrollView *sv;
    UILabel *label;
    UIButton *leftButton;
    UIButton *rightButton;
    
    UIPageControl *pageView;
    NSArray *imgArr;
    
    MyScrollViewStyle myStyle;
}
@end


@implementation SSTScrollView

CGFloat bottomViewH=55;

// 滚动
+(instancetype)scrollViewWithFrame:(CGRect)frame style:(MyScrollViewStyle)style imgArray:(NSArray*)imgArray titleArr:(NSArray*)titleArr timer:(NSTimeInterval)time{

    SSTScrollView *sv=[[SSTScrollView alloc]initWithFrame:frame style:style imgArray:imgArray titleArr:titleArr timer:time];
    return sv;
}

// 图片查看器
+(void)imgPickInView:(UIView*)view withURLArr:(NSArray*)urlArr{
    
    SSTScrollView *sv=[[SSTScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:MyScrollViewStyleImgPick imgArray:urlArr titleArr:nil timer:0];
    [sv setBackgroundColor:[UIColor blackColor]];
    sv.alpha=0.2;
    [view addSubview:sv];
    [UIView animateWithDuration:0.4 animations:^{
        sv.alpha=1;
    }];
}

-(instancetype)initWithFrame:(CGRect)frame style:(MyScrollViewStyle)style imgArray:(NSArray*)imgArray titleArr:(NSArray*)titleArr timer:(NSTimeInterval)time{
    
    self=[super initWithFrame:frame];
    if (self){
        myStyle=style;
        
        imgArr=[[NSArray alloc]initWithArray:imgArray];
        
        Boolean isImgPick=false;
        if(style == MyScrollViewStyleImgPick){
            isImgPick=true;
        }
        if (titleArr==nil||[titleArr count]==0){
            sv=[SSTGDScrollView scrollViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) imgArr:imgArr titleArr:nil time:time imgPick:isImgPick];
        }else{
            style = MyScrollViewStyleDownLabel;
            sv=[SSTGDScrollView scrollViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) imgArr:imgArr titleArr:titleArr time:time imgPick:isImgPick];
        }
        
        sv.tag=40;
        sv.svDelegate=self;
        [self addSubview:sv];
        
        // label----标签
        if (style == MyScrollViewStyleLabel){
            //
            float labelWH=40;
            label=[[UILabel alloc]initWithFrame: CGRectMake(frame.size.width-labelWH-gap, frame.size.height-labelWH-gap, labelWH, labelWH)];
            label.tag=50;
            label.text=[NSString stringWithFormat:@"1/%lu",(unsigned long)imgArr.count];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor=[UIColor colorWithWhite:0.95 alpha:1];
            
            label.font=[UIFont systemFontOfSize:18];
            label.textColor=[UIColor colorWithWhite:0.5 alpha:1];
            
            label.layer.cornerRadius=label.frame.size.width/2;
            label.layer.masksToBounds=true;
            [self addSubview:label];
        }
        
        // button----前一张、后一张
        if (style == MyScrollViewStyleButton){
            
            int buttonW=42;
            for (int i=0;i<2;i++){
                
                UIButton *button=[[UIButton alloc]init];
                
                button.backgroundColor=[UIColor clearColor];
 
                button.tag=100+i;
                [button addTarget:self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];
                if (i==0){
                    button.frame=CGRectMake(0, 0, buttonW, frame.size.height);
                    [button setImage:[UIImage imageNamed:@"btn_prepage"] forState:UIControlStateNormal];
                    leftButton=button;
                    [self addSubview:leftButton];
                }else if (i==1){
                    button.frame=CGRectMake(frame.size.width-buttonW, 0, buttonW, frame.size.height);
                    [button setImage:[UIImage imageNamed:@"btn_nextpage"] forState:UIControlStateNormal];
                    rightButton=button;
                    [self addSubview:rightButton];
                }
            }
        }
        
        
        // pageControl----
        if (style == MyScrollViewStylePageC){
            
            int pageCH=frame.size.height/9;
            pageView=[[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height-pageCH, frame.size.width, pageCH)];
            pageView.backgroundColor=[UIColor colorWithWhite:0.40 alpha:0.3];
            pageView.currentPageIndicatorTintColor=[UIColor brownColor];
            pageView.pageIndicatorTintColor=[UIColor whiteColor];
            pageView.currentPage=0;
            pageView.numberOfPages=imgArr.count;
            [self addSubview:pageView];
        }

        if(style == MyScrollViewStyleImgPick){
            
            //
            UIView *bottomView=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomViewH, SCREEN_WIDTH, bottomViewH)];
//            [bottomView setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
            [self addSubview:bottomView];
            //
            CGFloat pageLabelW=120;
            CGFloat pageLabelH=20;
            label=[[UILabel alloc]initWithFrame:CGRectMake(20, bottomView.frame.size.height/2-pageLabelH/2, pageLabelW, pageLabelH)];
            label.tag=50;
            label.text=[NSString stringWithFormat:@"当前张数 1/%lu",(unsigned long)imgArr.count];
            label.textAlignment = NSTextAlignmentLeft;
            label.font=[UIFont boldSystemFontOfSize:18];
            label.textColor=[UIColor whiteColor];
            [bottomView addSubview:label];
        }
    }
    
    return self;
}

//
-(void)handleButton:(UIButton*)button{
    
    if (button.tag==100){   // left
        // currentIndex（起始值为1，1s后+1）    根据currentIndex设置偏移量
        sv.currentIndex-=1;
        //
        [UIView animateWithDuration:1 animations:^{
            
            sv.contentOffset=CGPointMake(sv.currentIndex*self.frame.size.width, 0);
        } completion:^(BOOL finished) {
   
            if (sv.currentIndex == 0){   // 前面的最后一张图片
                sv.contentOffset=CGPointMake(self.frame.size.width*imgArr.count, 0);          // 跳到最后一张图片
                sv.currentIndex = (int)imgArr.count;                      // 重置为（最后一张）
            }
            [self endScroll];
        }];
    }else if (button.tag==101){  // right
        
        // currentIndex（起始值为1，1s后+1）    根据currentIndex设置偏移量
        sv.currentIndex+=1;
        //
        [UIView animateWithDuration:1 animations:^{
            sv.contentOffset=CGPointMake(sv.currentIndex*self.frame.size.width, 0);
        } completion:^(BOOL finished) {
            
            if (sv.currentIndex==imgArr.count+1){   // 后面的第一张图片
                sv.contentOffset=CGPointMake(self.frame.size.width, 0);     // 跳到第一张图片
                sv.currentIndex = 1 ;                   // 重置为1（第一张）
            }
            [self endScroll];
        }];
    }

}

// delegate （点击图片调用）
-(void)handleTap:(UIImageView*)imageV{
    if(myStyle==MyScrollViewStyleImgPick){
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        
        [self.dele handleTap:imageV];
    }
}
-(void)endScroll{

    label.text=[NSString stringWithFormat:@"%d/%d",sv.currentIndex,(int)imgArr.count];
    pageView.currentPage=sv.currentIndex-1;
}
@end
