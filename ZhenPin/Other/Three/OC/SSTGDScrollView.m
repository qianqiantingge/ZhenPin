//
//  SSTGDScrollView.m
//  SSTNews
//
//  Created by qianfeng on 16/8/29.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "SSTGDScrollView.h"
#import "UIImageView+WebCache.h"



@interface SSTGDScrollView(){

    NSTimer *timer;
    NSTimeInterval time;
    NSMutableArray *imgArr;
}
@end


@implementation SSTGDScrollView


+(instancetype)scrollViewWithFrame:(CGRect)frame imgArr:(NSArray*)imgArray titleArr:(NSArray*)titleArr time:(NSTimeInterval)timeT imgPick:(BOOL)isImgPick{
    
    SSTGDScrollView *sv=[[SSTGDScrollView alloc]initWithFrame:frame imgArr:imgArray titleArr:titleArr time:timeT imgPick:isImgPick];
    return sv;
}
-(instancetype)initWithFrame:(CGRect)frame imgArr:(NSArray*)imgArray titleArr:(NSArray*)titleArr time:(NSTimeInterval)timeT imgPick:(BOOL)isImgPick{
    self=[super initWithFrame:frame];
    if (self){
        
        if ([imgArray count]==0||imgArray==nil){
            return nil;
        }else if ([imgArray count]==1){
            
            self.scrollEnabled=false;
            timeT=0;
        }
        // 配置属性
        self.pagingEnabled=true;
        self.showsVerticalScrollIndicator=false;
        self.showsHorizontalScrollIndicator=false;
        self.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.9];
        self.delegate=self;
        
        // 数据源 +2
        imgArr=[[NSMutableArray alloc]initWithArray:imgArray];
        [imgArr insertObject:imgArr[[imgArr count]-1] atIndex:0];
        [imgArr addObject:imgArr[1]];
        if(imgArr.count==3){   // 防止一张时滚动
            self.scrollEnabled=false;
        }
        
        // imgV
        for (int i=0;i<[imgArr count];i++){
        
            UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
            if (isImgPick){
                imgV.backgroundColor=[UIColor blackColor];
                imgV.contentMode=UIViewContentModeScaleAspectFit;
            }
            [imgV sd_setImageWithURL:[NSURL URLWithString:imgArr[i]]];
            imgV.tag=i;
            imgV.userInteractionEnabled=true;
            UITapGestureRecognizer *tapG=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
            [imgV addGestureRecognizer:tapG];
            [self addSubview:imgV];
            
            //
            if ([titleArr count]!=0){
                float labelH=frame.size.height*1/5;
                float labelW=frame.size.width;
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, imgV.frame.size.height-labelH, labelW, labelH)];
                label.tag=190;
                if (i==0){
                    label.text=titleArr[titleArr.count-1];
                }else if(i==imgArr.count-1){
                    label.text=titleArr[0];
                }else{
                    label.text=titleArr[i-1];
                }
                label.textAlignment=NSTextAlignmentCenter;
                label.backgroundColor=[UIColor colorWithWhite:0.13 alpha:0.55];
                label.font=[UIFont systemFontOfSize:16];
                label.textColor=[UIColor colorWithWhite:0.96 alpha:1];
                [imgV addSubview:label];
            }
        }
        
        self.contentSize=CGSizeMake(frame.size.width*imgArr.count, frame.size.height);
        self.contentOffset=CGPointMake(frame.size.width, 0);
        
        if (timeT>0){
            time=timeT;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startTimer];
            });
        }
    }
    return self;
}

// 点击图片时调用
-(void)handleTap:(UITapGestureRecognizer*)tapG{
    [_svDelegate handleTap:(UIImageView*)tapG.view];
}

// 启动计时器（更新图片）
-(void)startTimer{

    timer=[NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(changePhot) userInfo:nil repeats:true];
}
// 暂停计时器
-(void)stopTimer{
    [timer invalidate];
}
-(void)changePhot{

    if(imgArr.count==3){   // 防止一张
        return;
    }
    /*
     0         1...count-2      count-1        (currentIndex)
     最后一张    第一张  最后一张      第一张
     
     原理：先滚动再判断（临界值跳）。
     
     滚到后面的第一张时          立即滚动到第一张
     滚动到前面的最后一张时       立即滚动到最后一张
     一到临界值就跳到内部（永不超出临界值）
     
     */
    
    _currentIndex+=1;
    [UIView animateWithDuration:1 animations:^{
        self.contentOffset=CGPointMake(_currentIndex*self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        if (_currentIndex==imgArr.count-1){   // 后面的第一张
        
            self.contentOffset=CGPointMake(self.frame.size.width, 0);
            _currentIndex=1;
        }
        [_svDelegate endScroll];
    }];
}




-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (timer!=nil){
        [self stopTimer];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    // 获取偏移量 0~imgArr.count-1（瞬间跳---后面的第一张跳到第一张，前面的最后一张跳到最后一张）
    int x=scrollView.contentOffset.x/scrollView.frame.size.width;
    if (x==imgArr.count-1){
        self.contentOffset=CGPointMake(self.frame.size.width, 0);
    }else if(x==0){
        self.contentOffset=CGPointMake(self.frame.size.width*(imgArr.count-2), 0);
    }
    
    // 用于计时器循环滚动（也得管 第一张）记录当前第几张
    _currentIndex=x==imgArr.count-1?1:(x==0?(int)imgArr.count-2:x);
    if (timer!=nil){
        [self startTimer];
    }
    
    [_svDelegate endScroll];
}
@end
