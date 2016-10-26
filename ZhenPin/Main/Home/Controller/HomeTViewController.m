//
//  HomeTViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HomeTViewController.h"
#import "Common.h"
#import "MJRefresh.h"
#import "HomeModel.h"
#import "HomeTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ContentTableViewCell.h"
#import "ADViewController.h"
#import "GoodItemViewController.h"
#import "DetailsViewController.h"

@interface HomeTViewController ()<UITableViewDelegate,UITableViewDataSource,HomeCateViewControllerProtocol>{

    ADModel *_adM;
    NSArray *_cateArr;
    NSArray *_contentArr;
    NSMutableArray *_dataArr;
    
    UITableView *_contentTV;
    UIView *_headView;
    
    int _page;
}
@end

@implementation HomeTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr=[[NSMutableArray alloc]init];
    _page=1;
    [self createUI];
}

//
-(void)loadContentData{
    [HomeModel requestDataWithPage:_page pageId:_pageId call:^(ADModel *adM, NSArray *cateArr, NSArray *contentArr, NSArray *dataArr, NSError *error) {
        
        if(adM!=nil){
            _adM=adM;
            _cateArr=cateArr;
            _contentArr=contentArr;
            
            if(_headView==nil){
                [self createHead];
            }
        }
        [_dataArr addObjectsFromArray:dataArr];
        
        [_contentTV reloadData];
        [_contentTV.mj_header endRefreshing];
        [_contentTV.mj_footer endRefreshing];
    }];
}

//
-(void)createHead{

    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentTV.frame.size.width, 540)];
    
    //
    UIView *headOneV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _headView.frame.size.width, 320)];
    [headOneV setBackgroundColor:[UIColor whiteColor]];
    [headOneV.layer setCornerRadius:5];
    [headOneV.layer setMasksToBounds:true];
    [_headView addSubview:headOneV];
    //
    UIImageView *bigImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    [bigImgV setUserInteractionEnabled:true];
    [bigImgV setTag:100];
    [bigImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
    [bigImgV sd_setImageWithURL:[NSURL URLWithString:_adM.imgUrl]];
    [headOneV addSubview:bigImgV];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, bigImgV.frame.size.height-30, bigImgV.frame.size.width, 30)];
    [titleLabel setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:_adM.title];
    [bigImgV addSubview:titleLabel];
    //
    UILabel *titlLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(bigImgV.frame)+10, 120, 25)];
    [titlLabel setFont:[UIFont systemFontOfSize:14]];
    [titlLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [titlLabel setTextAlignment:NSTextAlignmentLeft];
    [titlLabel setText:@"热门推荐"];
    [headOneV addSubview:titlLabel];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlLabel.frame)+10, headOneV.frame.size.width, 1.5)];
    [lineView setBackgroundColor:BGCOLOR];
    [headOneV addSubview:lineView];
    //
    CGFloat widthL=10;
    CGFloat numL=0;
    for(int i=0;i<_cateArr.count;i++){
        UIButton *button=[[UIButton alloc]init];
        [button setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1]];
        [button setTitle:_cateArr[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:true];
        [button.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:1].CGColor];
        [button.layer setBorderWidth:0.5];
        [button setTag:120+i];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [headOneV addSubview:button];
        
        CGFloat width=[(NSString*)_cateArr[i] boundingRectWithSize:CGSizeMake(300, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.width+17;
        if(widthL+width>headOneV.frame.size.width-20){
            numL+=1;
            widthL=10;
        }
        [button.layer setCornerRadius:15];
        button.frame=CGRectMake(widthL, CGRectGetMaxY(lineView.frame)+10+numL*(30+10), width, 30);
        
        widthL+=width+gap;
    }
    headOneV.frame=CGRectMake(0, 0, headOneV.frame.size.width, CGRectGetMaxY(lineView.frame)+10+(1+numL)*(30+10));
    
    //
    UIView *headTwoV=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headOneV.frame)+10, _headView.frame.size.width, _contentArr.count*110)];
    [headTwoV setBackgroundColor:[UIColor whiteColor]];
    [headTwoV.layer setCornerRadius:5];
    [headTwoV.layer setMasksToBounds:true];
    [_headView addSubview:headTwoV];
    //
    UITableView *contentTV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, headTwoV.frame.size.width, headTwoV.frame.size.height) style:UITableViewStylePlain];
    [contentTV setTag:100];
    [contentTV.layer setCornerRadius:5.0];
    [contentTV.layer setMasksToBounds:true];
    [contentTV setDelegate:self];
    [contentTV setDataSource:self];
    [contentTV setBackgroundColor:[UIColor whiteColor]];
    [contentTV setSeparatorInset:UIEdgeInsetsZero];
    [contentTV registerNib:[UINib nibWithNibName:@"ContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContentTableViewCell"];
    [headTwoV addSubview:contentTV];
    
    [_headView setFrame:CGRectMake(0, 0, _headView.frame.size.width, CGRectGetMaxY(headTwoV.frame)+gap)];
    [_contentTV setTableHeaderView:_headView];
}
//
-(void)createUI{

    //
    [self.view setBackgroundColor:BGCOLOR];
    //
    _contentTV=[[UITableView alloc]initWithFrame:CGRectMake(gap/2, 0, SCREEN_WIDTH-2*gap/2, SCREEN_HEIGHT-64-49-40) style:UITableViewStylePlain];
    [_contentTV setTag:101];
    [_contentTV setDelegate:self];
    [_contentTV setDataSource:self];
    [_contentTV setBackgroundColor:[UIColor clearColor]];
    [_contentTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_contentTV registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    _contentTV.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page=1;
        _adM=nil;
        _cateArr=nil;
        _contentArr=nil;
        [_dataArr removeAllObjects];
        [self loadContentData];
    }];
    _contentTV.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadContentData];
    }];
    [self.view addSubview:_contentTV];
}


// dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==100){
        return _contentArr.count;
    }else{
        return _dataArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==100){
        return 110;
    }else{
        return 345;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag==100){

        ItemTModel *itemM=_contentArr[indexPath.row];
        ContentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ContentTableViewCell"];
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:itemM.productImage]];
        [cell.titleLabel setText:itemM.brandName];
        [cell.contentLabel setText:itemM.customname];
        [cell.priceLabel setText:[NSString stringWithFormat:@"现价：%@",itemM.activityPrice]];
        [cell.oldPriceLabel setText:[NSString stringWithFormat:@"原价：%@",itemM.marketPrice]];
        
        return cell;
    }else{
        ContentModel *contentM=_dataArr[indexPath.row];
        
        HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
        [cell.bigImgV sd_setImageWithURL:[NSURL URLWithString:contentM.imgUrl]];
        [cell.smallImgV sd_setImageWithURL:[NSURL URLWithString:contentM.tag]];
        [cell.titleLabel setText:contentM.title];
        [cell setDataArr:contentM.itemArr];
        [cell setTi:contentM.title];
        [cell setImgUrl:contentM.jumpUrl];
        [cell setDele:self];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if(tableView.tag==100){
    
        GoodItemViewController *goodItemC=[[GoodItemViewController alloc]init];
        [goodItemC setProductId:((ItemModel*)_contentArr[indexPath.row]).productId];
        [self.dele pushVC:goodItemC];
    }
}




// 点击图片
-(void)handleTap:(UITapGestureRecognizer*)tapG{
    
    if(tapG.view.tag==100){     // ad
        
        ADViewController *adVC=[[ADViewController alloc]init];
        adVC.titl=_adM.title;
        adVC.url=_adM.jumpUrl;
        [self.dele pushVC:adVC];
    }
}
// 点击按钮
-(void)handleButton:(UIButton*)button{
    
    DetailsViewController *detailC=[[DetailsViewController alloc]init];
    detailC.url=[NSString stringWithFormat:@"%@",button.currentTitle];
    
    [self.dele pushVC:detailC];
}

// dele
-(void)pushVC:(UIViewController*)vc{
    [self.dele pushVC:vc];
}
@end
