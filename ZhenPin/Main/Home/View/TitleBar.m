//
//  TitleBar.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "TitleBar.h"
#import <UIKit/UIKit.h>


@interface TitleBar()<UIScrollViewDelegate>{

    //
    int currentTabSelected;          // 当前 选中index
    Boolean isUseDragging;           // 是否 是手指触摸滚动（用于立刻更新、滚动结束再更新）
    Boolean isLess;                  // 是否 所有button长度少于屏幕宽（用于规定button大小、滚动topSV）
    
    // 是否边界
    NSTimeInterval time;           // 当前button处于边界时topSV滚动时间
    CGFloat currentTopLeft;        // 用于判断是否处于边界
    CGFloat currentTopRight;       // 用于判断是否处于边界
    
    // UI
    UIScrollView *tabView;         // topSV
    UIView *lineView;              // line
    UIScrollView *bodySV;          // bodySV
    
    // dot/button Arr
    NSMutableArray *tabRedDotArr;    // 红点Arr(用于隐藏、显示)
    NSMutableArray *tabButtonArr;    // buttonArr
    
    // dele
    id<TitleBarProtocol> _dele;
    // vcArr
    NSArray *_vcArr;
}
@end



@implementation TitleBar

// 常量
const CGFloat lineBigButtonLeft=2;               // line 左边超出button(在button总长度>屏幕宽时有效，<时规定了固定大小)
const CGFloat lineH=2.3;                         // line 高
const CGFloat tabHeight=40;                      // tabBar 高
const CGFloat tabButtonFontSize=14;              // tabBarButton 字体大小
const CGFloat tabMargin=15;                      // tabBarButton 间距
#define tabBgColor [UIColor colorWithWhite:0.99 alpha:1]                        // tabBar bgColor
#define tabButtonTitleColorNormal [UIColor colorWithWhite:0.45 alpha:1]         // tabBar button标题颜色(normal)
#define tabButtonTitleColorSelected [UIColor blackColor]                        // tabBar button标题颜色(selected)
#define lineColor [UIColor colorWithRed:0 green:120.0/255 blue:255.0/255 alpha:1] // line color




+(instancetype)TitleBarWithFrame:(CGRect)frame vcArr:(NSArray*)vcArr dele:(id<TitleBarProtocol>)dele{
    
    TitleBar *titleBar=[[TitleBar alloc]initWithFrame:frame vcArr:vcArr dele:dele];
    
    return titleBar;
}
-(instancetype)initWithFrame:(CGRect)frame vcArr:(NSArray*)vcArr dele:(id<TitleBarProtocol>)dele{
    if(self=[super initWithFrame:frame]){
        
        _vcArr=vcArr;
        _dele=dele;
    
        [self initData];
        [self createUI];
    }
    return self;
}

// data
-(void)initData{
    time=1.2;
    currentTopLeft=0;
    currentTopRight=0;
    
    tabRedDotArr=[[NSMutableArray alloc]init];
    tabButtonArr=[[NSMutableArray alloc]init];
    currentTabSelected=0;
    isUseDragging=false;
    isLess=false;
}
//
-(void)createUI{
    
    // topSV
    tabView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, tabHeight)];
    tabView.showsHorizontalScrollIndicator=false;   // 滚动条不可见
    tabView.backgroundColor=tabBgColor;             // bgColor
    [self addSubview:tabView];
    // bodySV
    bodySV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, tabHeight, self.frame.size.width, self.frame.size.height-tabHeight)];
    bodySV.delegate=self;
    bodySV.bounces=false;
    bodySV.pagingEnabled=true;
    bodySV.showsHorizontalScrollIndicator=true;
    [self addSubview:bodySV];
    
    CGFloat widthL=tabMargin;       // 记录每个button距屏幕的左边距
    for(int i=0;i<_vcArr.count;i++){
        // itemButton       （topSV）
        UIButton *itemButton=[[UIButton alloc]init];
        CGFloat itemButtonWidth;
        itemButtonWidth=[((UIViewController*)_vcArr[i]).title boundingRectWithSize:CGSizeMake(1000, self.frame.size.height-lineH-5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:tabButtonFontSize]} context:nil].size.width+5;
        itemButton.frame=CGRectMake(widthL, 0, itemButtonWidth, tabHeight);
        itemButton.tag=300+i;
        itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemButton.titleLabel.font=[UIFont systemFontOfSize:tabButtonFontSize];
        [itemButton setTitle:((UIViewController*)_vcArr[i]).title forState: UIControlStateNormal];
        [itemButton setTitleColor:tabButtonTitleColorNormal forState: UIControlStateNormal];
        [itemButton setTitleColor:tabButtonTitleColorSelected forState: UIControlStateSelected];
        [itemButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:itemButton];
        [tabButtonArr addObject:itemButton];
        
        // 小红点             （topSV）
        UIView *aRedDotView=[[UIView alloc]initWithFrame:CGRectMake(itemButton.frame.size.width/2+3, itemButton.frame.size.height/2, 8, 8)];
        aRedDotView.backgroundColor=[UIColor redColor];
        aRedDotView.layer.cornerRadius=aRedDotView.frame.size.width/2;
        aRedDotView.layer.masksToBounds=true;
        aRedDotView.hidden=true;
        [itemButton addSubview:aRedDotView];
        [tabRedDotArr addObject:aRedDotView];
        
        // line             （topSV）
        if (i==0){
            lineView=[[UIView alloc]initWithFrame:CGRectMake(itemButton.frame.origin.x, itemButton.frame.size.height-lineH-5, itemButtonWidth, lineH)];
            lineView.tag=366;
            lineView.backgroundColor=lineColor;
            [tabView addSubview:lineView];
            
            // 默认选中button ， 当前选中下标
            itemButton.selected=true;
            currentTabSelected=0;
            itemButton.transform=CGAffineTransformMakeScale(1.05, 1.05);
        }
        // 更新左边距
        widthL+=itemButtonWidth+tabMargin;
        
        
        //                  （bodySV）
        [bodySV addSubview:((UIViewController*)_vcArr[i]).view];
    }
    
    //                      （topSV）
    if(widthL<self.frame.size.width){         // 不用滚动，总长度少于屏幕宽，重新更新button的间距
        
        isLess=true;
        CGFloat widthLe=(self.frame.size.width-(widthL-(tabButtonArr.count+1)*tabMargin))/(tabButtonArr.count+1);
        CGFloat ww=widthLe;
        for(int i=0;i<tabButtonArr.count;i++){
            UIButton *button=tabButtonArr[i];
            button.frame=CGRectMake(widthLe, 0, button.frame.size.width, button.frame.size.height);
            widthLe+=button.frame.size.width+ww;
        }
        UIView *lineV=[tabView viewWithTag:366];
        if(lineV != nil){
            lineV.frame=CGRectMake(((UIButton*)tabButtonArr[0]).frame.origin.x, lineV.frame.origin.y, ((UIButton*)tabButtonArr[0]).frame.size.width, lineV.frame.size.height);
        }
    }else{
        tabView.contentSize=CGSizeMake(widthL, tabView.frame.size.height);
    }
    
    //                      （bodySV）
    bodySV.contentSize=CGSizeMake(self.frame.size.width*_vcArr.count, tabHeight);
    for(int i=0;i<_vcArr.count;i++){
        ((UIViewController*)_vcArr[i]).view.frame=CGRectMake(bodySV.frame.size.width*i, 0, bodySV.frame.size.width, bodySV.frame.size.height);
//        if(i==0){    // 立即刷新第一页（使用了VC的view，会走viewDidLoad，此时tableView的mj_head才有值）
//            [_dele selectedWithIndex:0];
//        }
    }
}


// 处理按钮
-(void)handleButton:(UIButton*)button{
    isUseDragging=false;
    [self selectTabWithIndex:(int)button.tag-300 isAnimate: true];
}
// 改变 项
-(void)selectTabWithIndex:(int)index isAnimate:(Boolean)isAnimate{
    
    // button和line
    if(!isUseDragging){  // 点击时立刻更新button
        [self updateButton:index];
    }
    // 当前button
    UIButton *button=tabButtonArr[index];
    // 更新line的位置
    __weak typeof(self) weakSelf=self;
    [UIView animateWithDuration:0.35 animations:^{
        
        // line位置
        CGRect frame=lineView.frame;
        frame.origin.x=button.frame.origin.x-lineBigButtonLeft;
        frame.size.width=button.frame.size.width+lineBigButtonLeft*2;
        lineView.frame=frame;

    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf=weakSelf;
        if(strongSelf->isUseDragging){
            [weakSelf updateButton:index];
        }
    }];
    
    // bodySV
    // 是点击                      （要滑动bodySV）
    if(!isUseDragging){
        // 滚动bodySV
        [UIView animateWithDuration:1.5 animations:^{
            [bodySV setContentOffset:CGPointMake(index*self.frame.size.width, 0) animated: isAnimate];
        }];
    }
    
    // topSV
    // button总长度大于屏幕宽       （要在button处于边界的时候，滚动topSV）
    if(!isLess){
        
        CGFloat maxX=tabView.contentSize.width;             // contentSize宽度
        UIButton *button=tabButtonArr[index];               // 当前button
        if(CGRectGetMaxX(button.frame)>(self.frame.size.width+currentTopLeft)){     // 右边界在屏幕外（往右）
            
            if(maxX-CGRectGetMinX(button.frame)<self.frame.size.width){ // 不够完整左移
                [UIView animateWithDuration:time animations:^{
                    tabView.contentOffset=CGPointMake(maxX-self.frame.size.width, 0);    // 偏移量
                }];
                // 更新left
                currentTopLeft=maxX-self.frame.size.width;    // 就是偏移量
                currentTopRight=maxX;                         // 就是偏移量+屏幕宽
            }else{                                      // 够
                [UIView animateWithDuration:time animations:^{
                    tabView.contentOffset=CGPointMake(CGRectGetMinX(button.frame), 0);
                }];
                // 更新left
                currentTopLeft=button.frame.origin.x;
                currentTopRight=currentTopLeft+self.frame.size.width;
            }
        }
        if(CGRectGetMinX(button.frame)<(currentTopRight-self.frame.size.width)){      // 左边界在屏幕外（往左）
            
            if(CGRectGetMaxX(button.frame)-0<self.frame.size.width){    // 不够
                [UIView animateWithDuration:time animations:^{
                    tabView.contentOffset=CGPointMake(0, 0);
                }];
                currentTopLeft=0;
                currentTopRight=currentTopLeft+self.frame.size.width;
            }else{      //
                [UIView animateWithDuration:time animations:^{
                    tabView.contentOffset=CGPointMake(CGRectGetMaxX(button.frame)-self.frame.size.width, 0);
                }];
                currentTopLeft=CGRectGetMaxX(button.frame)-self.frame.size.width;
                currentTopRight=currentTopLeft+self.frame.size.width;
            }
        }
    }
    
    // 隐藏小红点（查阅了，所以隐藏）
    [self hideTabRedDot:index];
    
    // 调用delegate的 选中某项并滚动完毕后调用
    [_dele selectedWithIndex:index];
}

// 显示小红点
-(void)showTabRedDot:(int)index{
    ((UIView*)tabRedDotArr[index]).hidden=false;
}
// 隐藏小红点
-(void)hideTabRedDot:(int)index{
    ((UIView*)tabRedDotArr[index]).hidden=true;
}


// 更新选中button的颜色，并记录当前下标
-(void)updateButton:(int)x{
    UIButton *bu=tabButtonArr[currentTabSelected];
    bu.selected=false;
    UIButton *buC=tabButtonArr[x];
    buC.selected=true;
    currentTabSelected=x;
    [UIView animateWithDuration:0.3 animations:^{
        bu.transform=CGAffineTransformIdentity;
        buC.transform=CGAffineTransformMakeScale(1.05, 1.05);
    }];
}






// 滚动完毕后调用，设置偏移量不调用（只有手拖动后）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView==bodySV){     // 防止滚动topSV时也调用
        isUseDragging=true;
        [self selectTabWithIndex:scrollView.contentOffset.x/self.bounds.size.width isAnimate: true];
    }
}

// 滚动时调用（连续触发）
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView==bodySV && isUseDragging){        // 是滑动
        if(scrollView.contentOffset.x>0 && scrollView.contentOffset.x<(tabButtonArr.count-1)*self.frame.size.width){    // 最左边< _ <最右边
            if(isLess){     // 只在 button总长度小于屏幕宽时
                // line位置
                CGRect frame=lineView.frame;
                frame.origin.x=scrollView.contentOffset.x/tabButtonArr.count;
                lineView.frame=frame;
                
                // 更新button标题
                CGFloat x=CGRectGetMidX(lineView.frame)<self.frame.size.width/tabButtonArr.count ? 0 : CGRectGetMidX(lineView.frame)<self.frame.size.width/(tabButtonArr.count)*2 ? 1: 2;
                [self updateButton:x];
            }
        }
    }
}

@end
