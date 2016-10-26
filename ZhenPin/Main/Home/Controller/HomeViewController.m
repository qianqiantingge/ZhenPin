//
//  HomeViewController.m
//  SSTGood
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeModel.h"
#import "Common.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "SSTScrollView.h"
#import "HomeTableViewCell.h"
#import "GoodItemCollectionViewCell.h"
#import "ADViewController.h"
#import "MSViewController.h"
#import "HDManager.h"
#import "UserModel.h"
#import "LoginViewController.h"

@interface HomeViewController ()<SSTGDScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomeCateViewControllerProtocol>{

    NSArray *_adArr;
    NSArray *_headArr;
    NSArray *_contentArr;
    NSMutableArray *_dataArr;
 
    NSArray *_msArr;
    int _page;
    
    UIView *_headView;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    _page=1;
    _dataArr=[[NSMutableArray alloc]init];
    [self createUI];
    [self loadHeadData];
}
-(void)loadHeadData{

    [HDManager startLoading];
    [HeadModel requestHeadData:^(NSArray *adArr, NSArray *cateArr, NSError *error) {
        
        _adArr=adArr;
        _headArr=cateArr;
        
        [MSModel requestData:^(NSArray *contentArr, NSError *error) {
            _contentArr=contentArr;
            [self createHead];
            [self loadContentData];
            [HDManager stopLoading];
        }];
    }];
}
-(void)loadContentData{
    
    [ContentModel requestDataWithPage:_page pageId:_pageId call:^(NSArray *contentArr, NSError *error) {
        if(error==nil){
            if(_page==1){
                [_dataArr removeAllObjects];
            }
            [_dataArr addObjectsFromArray:contentArr];
            [_dataArr removeObjectAtIndex:0];
            [_contentTV reloadData];
            if([_contentTV.mj_header isRefreshing]){
                [_contentTV.mj_header endRefreshing];
            }else if([_contentTV.mj_footer isRefreshing]){
                [_contentTV.mj_footer endRefreshing];
            }
        }
    }];
}

-(void)createUI{
    
    //
    [self.view setBackgroundColor:BGCOLOR];
    //
    _contentTV=[[UITableView alloc]initWithFrame:CGRectMake(gap/2, 0, SCREEN_WIDTH-2*gap/2, SCREEN_HEIGHT-64-49-40) style:UITableViewStylePlain];
    [_contentTV setDelegate:self];
    [_contentTV setDataSource:self];
    [_contentTV setBackgroundColor:[UIColor clearColor]];
    [_contentTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_contentTV registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeTableViewCell"];
    _contentTV.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page=1;
        [self loadContentData];
    }];
    _contentTV.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page+=1;
        [self loadContentData];
    }];
    [self.view addSubview:_contentTV];
}
-(void)createHead{

    ADModel *adM=[_adArr firstObject];
    MSModel *msM=[_contentArr firstObject];
    _msArr=msM.brandArr;
    
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _contentTV.frame.size.width, 520)];
    [_contentTV setTableHeaderView:_headView];
    
    //
    UIView *headOneV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _headView.frame.size.width, 300)];
    [headOneV setBackgroundColor:[UIColor whiteColor]];
    [headOneV.layer setCornerRadius:5];
    [headOneV.layer setMasksToBounds:true];
    [_headView addSubview:headOneV];
    //
    UIImageView *bigImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220)];
    [bigImgV setUserInteractionEnabled:true];
    [bigImgV setTag:500];
    [bigImgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
    [bigImgV sd_setImageWithURL:[NSURL URLWithString:adM.imgUrl]];
    [headOneV addSubview:bigImgV];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, bigImgV.frame.size.height-30, bigImgV.frame.size.width, 30)];
    [titleLabel setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:adM.title];
    [bigImgV addSubview:titleLabel];
    //
    CGFloat width=headOneV.frame.size.width/_headArr.count;
    for (int i=0; i<_headArr.count; i++) {
        
        HeadModel *headM=_headArr[i];
        
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(width*i, CGRectGetMaxY(bigImgV.frame), width, headOneV.frame.size.height-bigImgV.frame.size.height)];
        [button setTag:200+i];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [headOneV addSubview:button];
        //
        UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width/2-38/2, gap, 38, 38)];
        [imgV.layer setCornerRadius:imgV.frame.size.width/2];
        [imgV.layer setMasksToBounds:true];
        [imgV sd_setImageWithURL:[NSURL URLWithString:headM.img]];
        [button addSubview:imgV];
        //
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame)+5, button.frame.size.width, 18)];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextColor:[UIColor grayColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:headM.name];
        [button addSubview:label];
    }
    
    //
    UIView *headTwoV=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headOneV.frame)+10, _headView.frame.size.width, 200)];
    [headTwoV setBackgroundColor:[UIColor whiteColor]];
    [headTwoV.layer setCornerRadius:5];
    [headTwoV.layer setMasksToBounds:true];
    [_headView addSubview:headTwoV];
    //
    //
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headTwoV.frame.size.width, 42)];
    [button setTag:300];
    [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [headTwoV addSubview:button];
    UILabel *titlLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 22)];
    [titlLabel setFont:[UIFont systemFontOfSize:14]];
    [titlLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [titlLabel setTextAlignment:NSTextAlignmentLeft];
    [titlLabel setText:msM.name];
    [button addSubview:titlLabel];
    UIImageView *moreImgV=[[UIImageView alloc]initWithFrame:CGRectMake(headTwoV.frame.size.width-10-10, CGRectGetMidY(titlLabel.frame)-10/2, 6, 10)];
    [moreImgV setImage:[UIImage imageNamed:@"more"]];
    [button addSubview:moreImgV];
    UILabel *moreLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(moreImgV.frame)-5-50, 10, 50, 22)];
    [moreLabel setFont:[UIFont systemFontOfSize:12]];
    [moreLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [moreLabel setTextAlignment:NSTextAlignmentRight];
    [moreLabel setTextColor:[UIColor grayColor]];
    [moreLabel setText:@"点击开抢"];
    [button addSubview:moreLabel];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), headTwoV.frame.size.width, 1.5)];
    [lineView setBackgroundColor:BGCOLOR];
    [headTwoV addSubview:lineView];
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing:gap*2];
    [layout setMinimumInteritemSpacing:gap*2];
    //
    UICollectionView *colV=[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), headTwoV.frame.size.width, headTwoV.frame.size.height-CGRectGetMaxY(lineView.frame)) collectionViewLayout:layout];
    [colV setBackgroundColor:[UIColor clearColor]];
    [colV setCollectionViewLayout:layout];
    [colV registerNib:[UINib nibWithNibName:@"GoodItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodItemCollectionViewCell"];
    colV.delegate=self;
    colV.dataSource=self;
    [headTwoV addSubview:colV];
    
}

// 点击按钮
-(void)handleButton:(UIButton*)button{

    
    
    if(button.tag>=200 && button.tag<200+_headArr.count){
        
        //
        UserModel *userM=[UserModel shareInatance];
        
        if(userM.memberid!=nil){
            HeadModel *headM=_headArr[button.tag-200];
            ADViewController *adVC=[[ADViewController alloc]init];
            adVC.titl=headM.name;
            if(button.tag==203){
                adVC.url=headM.url;
            }else{
                adVC.url=[NSString stringWithFormat:@"%@&memberId=%@&token=%@",headM.url,userM.memberid,userM.token];
            }
            [self.dele pushVC:adVC];
        }else{
            LoginViewController *loginC=[[LoginViewController alloc]init];
            [self pushVC:loginC];
        }
    }else if(button.tag==300){  // 秒杀
        
        MSViewController *msC=[[MSViewController alloc]init];
        msC.titl=@"秒杀";
        msC.groupId=((MSModel*)_contentArr[0]).groupId;
        [self.dele pushVC:msC];
    }

    
}

// 点击图片
-(void)handleTap:(UITapGestureRecognizer*)tapG{

    if(tapG.view.tag==500){     // ad
        
        ADModel *adM=[_adArr firstObject];
        ADViewController *adVC=[[ADViewController alloc]init];
        adVC.titl=adM.title;
        adVC.url=adM.jumpUrl;
        [self.dele pushVC:adVC];
    }
}


// dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 345;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContentModel *contentM=_dataArr[indexPath.row];
    
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    cell.dele=self;
    [cell.bigImgV sd_setImageWithURL:[NSURL URLWithString:contentM.imgUrl]];
    [cell.smallImgV sd_setImageWithURL:[NSURL URLWithString:contentM.tag]];
    [cell.titleLabel setText:contentM.title];
    [cell setDataArr:contentM.itemArr];
    [cell setImgUrl:contentM.jumpUrl];
    [cell setTi:contentM.title];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}



// dele
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _msArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90, 140);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"GoodItemCollectionViewCell" forIndexPath:indexPath];
    cell.titleLabel.numberOfLines=1;
    BrandTModel *itemM=(BrandTModel*)_msArr[indexPath.row];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:itemM.msmall]];
    [cell.imgV setContentMode:UIViewContentModeScaleAspectFit];
    [cell.titleLabel setText:itemM.brandname];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%@",itemM.marketPrice]];
    [cell.oldPriceLabel setText:[NSString stringWithFormat:@"￥%@",itemM.premiumPrice]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MSViewController *msC=[[MSViewController alloc]init];
    msC.titl=@"秒杀";
    msC.groupId=((MSModel*)_contentArr[0]).groupId;
    [self.dele pushVC:msC];
}


// dele
-(void)pushVC:(UIViewController*)vc{
    [self.dele pushVC:vc];
}
@end
