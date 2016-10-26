//
//  GoodItemBottomView.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "GoodItemBottomView.h"
#import "Common.h"

@implementation GoodItemBottomView


+(GoodItemBottomView*)createBottomViewWithDelegate:(id<GoodItemBottomViewProTocol>)dele inView:(UIView*)view{

    GoodItemBottomView *goodItemView=[[GoodItemBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40)];
    goodItemView.dele=dele;
    [view addSubview:goodItemView];
    
    return  goodItemView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if(self){
        UIView *mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [mainView setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        [self addSubview:mainView];
        
        //
        //
        UIButton *carbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, mainView.frame.size.height)];
        [carbutton setTag:100];
        [carbutton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:carbutton];
        //
        UIImageView *smallImgV=[[UIImageView alloc]initWithFrame:CGRectMake(carbutton.frame.size.width/2-35/2, carbutton.frame.size.height/2-25/2, 25, 25)];
        [smallImgV setImage:[UIImage imageNamed:@"carcar"]];
        [carbutton addSubview:smallImgV];
        //
        _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(smallImgV.frame.size.width-15, 0, 15, 15)];
        [_countLabel setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.8]];
        [_countLabel.layer setCornerRadius:_countLabel.frame.size.width/2];
        [_countLabel.layer setMasksToBounds:true];
        [_countLabel setFont:[UIFont boldSystemFontOfSize:8]];
        [smallImgV addSubview:_countLabel];
        
        //
        //
        UIButton *addButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(carbutton.frame), 0, 130, mainView.frame.size.height)];
        [addButton setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [addButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addButton.layer setBorderWidth:1];
        [addButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [addButton setTag:101];
        [addButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:addButton];
        
        //
        //
        UIButton *buyButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addButton.frame), 0, mainView.frame.size.width-CGRectGetMaxX(addButton.frame), mainView.frame.size.height)];
        [buyButton setBackgroundColor:[UIColor redColor]];
        [buyButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
//        [buyButton setTag:102];
//        [buyButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:buyButton];

    }
        
    return self;
}

//
-(void)handleButton:(UIButton*)button{
    [self.dele handleButton:button];
}


@end
