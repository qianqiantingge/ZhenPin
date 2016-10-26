//
//  SelectedView.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/12.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "SelectedView.h"

#import "Common.h"
#import "UIView+MJExtension.h"

@implementation SelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        UIView * smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        smallView.backgroundColor = [UIColor whiteColor];
        [self addSubview:smallView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 50, 20)];
        label.text = @"只显示有货";
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        UISwitch * switchView = [[UISwitch alloc] initWithFrame:CGRectMake(100, 0, 40, 20)];
        [self addSubview:switchView];
        UIButton * priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 80, 40)];
        priceBtn.tag = 1111;
        [priceBtn setTitle:@"价位" forState:UIControlStateNormal];
        [self addSubview:priceBtn];
        [priceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedBtn = priceBtn;
        
        UIButton * colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 80, 40)];
        colorBtn.tag = 2222;
        [colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
        colorBtn.backgroundColor = BGCOLOR;
        [self addSubview:colorBtn];
        [colorBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.priceView = [[UIView alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 94 - 40 - 60)];
        [self addSubview:self.priceView];
        NSArray * array = @[@"全部", @"500以内", @"500-1000", @"1000-2000", @"2000-5000", @"5000-10000", @"10000以上"];
        for (int i = 0; i < array.count; i++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20 + (20 + 30), 100, 30)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.priceView addSubview:btn];
            btn.tag = 10 + i;
        }
        
        self.colorView = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 40, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 94 - 40 - 60)];
        [self addSubview:self.colorView];
        NSArray * colorArray = @[@"全部", @"卡其色", @"蓝绿色", @"花色", @"橙色", @"黑色", @"白色", @"紫色", @"粉色", @"灰色", @"蓝色", @"红色", @"棕色", @"绿色"];
        for (int i = 0; i < colorArray.count; i++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20 + (20 + 30), self.colorView.mj_w - 40, 30)];
            [self.colorView addSubview:btn];
            [btn setTitle:colorArray[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = 100 + i;
        }
    }
    return self;
}

- (void)btnClick: (UIButton *)sender{
    if (sender == self.selectedBtn) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor whiteColor];
    [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedBtn.backgroundColor = BGCOLOR;
    self.selectedBtn = sender;
    if (self.selectedBtn.tag == 1111) {
        self.colorView.hidden = YES;
    }else{
        self.priceView.hidden = YES;
    }
}

@end
