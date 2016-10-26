//
//  GoodItemViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "GoodItemViewController.h"
#import "SSTScrollView.h"
#import "UIImageView+WebCache.h"
#import "GoodItemModel.h"
#import "Common.h"
#import "HDManager.h"
#import "GoodItemCollectionViewCell.h"
#import "GoodItemViewController.h"
#import "GoodItemBottomView.h"
#import "UserModel.h"
#import "BaseRequest.h"

@interface GoodItemViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,GoodItemBottomViewProTocol>{

    GoodItemModel *_goodItemM;
    
    int currentTabSelected;
    
    UIView *headTwoView;
    
    GoodItemBottomView *_bottomView;
}
@end


@implementation GoodItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self.view setBackgroundColor:BGCOLOR];
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [self loadData];
}

-(void)loadData{
    
    [HDManager startLoading];
    [GoodItemModel requestDataWithProductId:_productId call:^(GoodItemModel *goodItemM, NSError *error) {
        _goodItemM=goodItemM;
        if(_goodItemM.productName==nil || [_goodItemM.productName isEqualToString:@""]){
            
            [self createOtherUI];
            [HDManager stopLoading];
        }else{
            [GoodItemModel requestDetailDataWithProductId:_productId call:^(GoodItemModel *goodItemM, NSError *error) {
                _goodItemM.brandImg=goodItemM.brandImg;
                _goodItemM.brandIntro=goodItemM.brandIntro;
                [GoodItemModel requestRecomendDataWithProductId:_productId call:^(GoodItemModel *goodItemM, NSError *error) {
                    _goodItemM.recomendArr=goodItemM.recomendArr;
                    
                    [self createUI];
                    [HDManager stopLoading];
                }];
            }];
        }
    }];
}

-(void)createOtherUI{
    
    //
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64+gap*5, SCREEN_WIDTH, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"抱歉，此商品已下架"];
    [self.view addSubview:titleLabel];
}
-(void)createUI{

    //
    UIScrollView *sv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
    [self.view addSubview:sv];
    //
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, sv.frame.size.width, 410)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [headView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    [headView.layer setBorderWidth:1.0];
    [sv addSubview:headView];
    SSTScrollView *adSV=[SSTScrollView scrollViewWithFrame:CGRectMake(40, gap, headView.frame.size.width-40*2, 300) style:MyScrollViewStyleLabel imgArray:_goodItemM.imgArr titleArr:nil timer:4.5];
    [adSV setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:adSV];
    //
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(gap*1.5, CGRectGetMaxY(adSV.frame)+gap*1.6, 200, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setText:_goodItemM.brandname];
    [headView addSubview:titleLabel];
    //
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+gap/5, 300, 20)];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setText:_goodItemM.productName];
    [headView addSubview:nameLabel];
    //
    UILabel *priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(nameLabel.frame)+gap, 70, 20)];
    [priceLabel setFont:[UIFont systemFontOfSize:20]];
    [priceLabel setTextColor:[UIColor redColor]];
    [priceLabel setTextAlignment:NSTextAlignmentLeft];
    [priceLabel setText:[NSString stringWithFormat:@"￥%@",_goodItemM.price]];
    [headView addSubview:priceLabel];
    //
    UILabel *oldPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+gap, CGRectGetMidY(priceLabel.frame)-20/2, 200, 20)];
    [oldPriceLabel setFont:[UIFont systemFontOfSize:13]];
    [oldPriceLabel setTextColor:[UIColor grayColor]];
    [oldPriceLabel setTextAlignment:NSTextAlignmentLeft];
    [oldPriceLabel setText:[NSString stringWithFormat:@"市场价：￥%@",_goodItemM.marketPrice]];
    [headView addSubview:oldPriceLabel];
    
    //
    headTwoView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+gap, SCREEN_WIDTH, 220)];
    [headTwoView setBackgroundColor:[UIColor whiteColor]];
    [headTwoView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    [headTwoView.layer setBorderWidth:1.0];
    [sv addSubview:headTwoView];
    //
    UILabel *titlLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 22)];
    [titlLabel setFont:[UIFont systemFontOfSize:15]];
    [titlLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [titlLabel setTextAlignment:NSTextAlignmentLeft];
    [titlLabel setText:[NSString stringWithFormat:@"颜色： %@",_goodItemM.colorText]];
    [headTwoView addSubview:titlLabel];
    //
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titlLabel.frame)+10, headTwoView.frame.size.width, 1.5)];
    [lineView setBackgroundColor:BGCOLOR];
    [headTwoView addSubview:lineView];
    //
    UIImageView *smallImgV=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(lineView.frame)+10/2, 60, 60)];
    [smallImgV sd_setImageWithURL:[NSURL URLWithString:_goodItemM.msmall]];
    [headTwoView addSubview:smallImgV];
    //
    UILabel *sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titlLabel.frame),CGRectGetMaxY(smallImgV.frame)+gap*1.6, 50, 22)];
    [sizeLabel setFont:[UIFont systemFontOfSize:15]];
    [sizeLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [sizeLabel setTextAlignment:NSTextAlignmentLeft];
    [sizeLabel setText:@"尺码："];
    [headTwoView addSubview:sizeLabel];
    //
    UIButton *sizebutton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sizeLabel.frame)+gap/2, CGRectGetMinY(sizeLabel.frame), 50, sizeLabel.frame.size.height)];
    [sizebutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sizebutton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [sizebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sizebutton setTitle:_goodItemM.sizeArr[0] forState:UIControlStateNormal];
    [sizebutton setTag:100];
    [sizebutton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [headTwoView addSubview:sizebutton];
    //
    UIButton *introButton=[[UIButton alloc]initWithFrame:CGRectMake(headTwoView.frame.size.width-gap*1.4-60, CGRectGetMinY(sizeLabel.frame), 60, sizeLabel.frame.size.height)];
    [introButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [introButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [introButton setTitle:@"尺码说明" forState:UIControlStateNormal];
//    [introButton setTag:101];
//    [introButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [headTwoView addSubview:introButton];
    //
    UIView *lineTView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sizeLabel.frame)+10, headTwoView.frame.size.width, 1.5)];
    [lineTView setBackgroundColor:BGCOLOR];
    [headTwoView addSubview:lineTView];
    //
    CGFloat widthL=gap*2;       // 记录每个button距屏幕的左边距
    for(int i=0;i<_goodItemM.sizeArr.count;i++){
        // itemButton       （topSV）
        UIButton *itemButton=[[UIButton alloc]init];
        CGFloat itemButtonWidth;
   
        itemButtonWidth=[_goodItemM.sizeArr[i] boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+25;
        itemButton.frame=CGRectMake(widthL, CGRectGetMaxY(lineTView.frame)+10, itemButtonWidth, 30);
        itemButton.tag=300+i;
        itemButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [itemButton setTitle:_goodItemM.sizeArr[i] forState: UIControlStateNormal];
        [itemButton setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [itemButton setTitleColor:[UIColor redColor] forState: UIControlStateSelected];
        [itemButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [headTwoView addSubview:itemButton];
        
        // line             （topSV）
        if (i==0){
            UIView *sizeLineView=[[UIView alloc]initWithFrame:CGRectMake(itemButton.frame.origin.x, CGRectGetMaxY(itemButton.frame), itemButtonWidth, 1.5)];
            sizeLineView.tag=500;
            sizeLineView.backgroundColor=[UIColor redColor];
            [headTwoView addSubview:sizeLineView];
            
            // 默认选中button ， 当前选中下标
            itemButton.selected=true;
            currentTabSelected=0;
            itemButton.transform=CGAffineTransformMakeScale(1.05, 1.05);
        }
        // 更新左边距
        widthL+=itemButtonWidth+gap*2;
    }
    
    //
    UIView *headThreeView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headTwoView.frame)+gap, SCREEN_WIDTH, 42+10+25*_goodItemM.detailArr.count+10)];
    [headThreeView setBackgroundColor:[UIColor whiteColor]];
    [headThreeView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    [headThreeView.layer setBorderWidth:1.0];
    [sv addSubview:headThreeView];
    //
    //
    UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 22)];
    [detailLabel setFont:[UIFont systemFontOfSize:15]];
    [detailLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [detailLabel setTextAlignment:NSTextAlignmentLeft];
    [detailLabel setText:[NSString stringWithFormat:@"商品详情"]];
    [headThreeView addSubview:detailLabel];
    //
    UIView *lineTTView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(detailLabel.frame)+10, headThreeView.frame.size.width, 1.5)];
    [lineTTView setBackgroundColor:BGCOLOR];
    [headThreeView addSubview:lineTTView];
    for(int i=0;i<_goodItemM.detailArr.count;i++){
        
        UILabel *detailItemLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(detailLabel.frame), CGRectGetMaxY(lineTTView.frame)+10+(20+5)*i, 300, 20)];
        [detailItemLabel setFont:[UIFont systemFontOfSize:14]];
        [detailItemLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        [detailItemLabel setTextAlignment:NSTextAlignmentLeft];
        [detailItemLabel setText:[NSString stringWithFormat:@"%@:  %@",((GoodDetailModel*)_goodItemM.detailArr[i]).attrname,((GoodDetailModel*)_goodItemM.detailArr[i]).attrvalues]];
        [headThreeView addSubview:detailItemLabel];
    }

    //
    UIView *headFourView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headThreeView.frame)+gap, SCREEN_WIDTH, 42+5+250*(_goodItemM.detailImgArr.count-4)+10)];
    [headFourView setBackgroundColor:[UIColor whiteColor]];
    [headFourView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    [headFourView.layer setBorderWidth:1.0];
    [sv addSubview:headFourView];
    //
    UILabel *detailImgLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 22)];
    [detailImgLabel setFont:[UIFont systemFontOfSize:15]];
    [detailImgLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [detailImgLabel setTextAlignment:NSTextAlignmentLeft];
    [detailImgLabel setText:[NSString stringWithFormat:@"图文详情"]];
    [headFourView addSubview:detailImgLabel];
    //
    UIView *lineTTTView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(detailImgLabel.frame)+10, headFourView.frame.size.width, 1.5)];
    [lineTTTView setBackgroundColor:BGCOLOR];
    [headFourView addSubview:lineTTTView];
    if(_goodItemM.detailImgArr.count>3){
        for(int i=1;i<_goodItemM.detailImgArr.count-3;i++){
            
            UIImageView *smallImgV=[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(lineTTTView.frame)+5+(250)*(i-1), headFourView.frame.size.width-20*2, 250)];
            [smallImgV sd_setImageWithURL:[NSURL URLWithString:_goodItemM.detailImgArr[i]]];
            [headFourView addSubview:smallImgV];
        }
    }
    
    
    //
    UIView *headFiveView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headFourView.frame)+gap, SCREEN_WIDTH, 42+5+75*_goodItemM.detailImgArr.count+10)];
    [headFiveView setBackgroundColor:[UIColor whiteColor]];
    [headFiveView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    [headFiveView.layer setBorderWidth:1.0];
    [sv addSubview:headFiveView];
    //
    UILabel *brandLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 22)];
    [brandLabel setFont:[UIFont systemFontOfSize:15]];
    [brandLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [brandLabel setTextAlignment:NSTextAlignmentLeft];
    [brandLabel setText:[NSString stringWithFormat:@"品牌详情"]];
    [headFiveView addSubview:brandLabel];
    //
    UIView *lineTTTTView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(brandLabel.frame)+10, headFiveView.frame.size.width, 1.5)];
    [lineTTTTView setBackgroundColor:BGCOLOR];
    [headFiveView addSubview:lineTTTTView];
    //
    UIImageView *brandImgV=[[UIImageView alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(lineTTTView.frame), headFourView.frame.size.width-80*2, 75)];
    if(_goodItemM.brandImg==nil){
        brandImgV.frame=CGRectMake(brandImgV.frame.origin.x, brandImgV.frame.origin.y, brandImgV.frame.size.width, 0);
    }
    [brandImgV sd_setImageWithURL:[NSURL URLWithString:_goodItemM.brandImg]];
    [headFiveView addSubview:brandImgV];
    //
    //
    CGFloat h=[_goodItemM.brandIntro boundingRectWithSize:CGSizeMake(headFourView.frame.size.width-20*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    UILabel *brandDetailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(brandImgV.frame), headFourView.frame.size.width-20*2, h)];
    [brandDetailLabel setNumberOfLines:0];
    [brandDetailLabel setFont:[UIFont systemFontOfSize:14]];
    [brandDetailLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [brandDetailLabel setTextAlignment:NSTextAlignmentLeft];
    [brandDetailLabel setText:[NSString stringWithFormat:@"%@",_goodItemM.brandIntro]];
    [headFiveView addSubview:brandDetailLabel];
    [headFiveView setFrame:CGRectMake(headFiveView.frame.origin.x, headFiveView.frame.origin.y, headFiveView.frame.size.width, CGRectGetMaxY(brandDetailLabel.frame)+15)];

    
    //
    UIView *headSixView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headFiveView.frame)+gap, SCREEN_WIDTH, 42+170)];
    [headSixView setBackgroundColor:[UIColor whiteColor]];
    [headFiveView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1].CGColor];
    [headFiveView.layer setBorderWidth:1.0];
    [sv addSubview:headSixView];
    //
    UILabel *recomendLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 150, 22)];
    [recomendLabel setFont:[UIFont systemFontOfSize:15]];
    [recomendLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [recomendLabel setTextAlignment:NSTextAlignmentLeft];
    [recomendLabel setText:[NSString stringWithFormat:@"为你推荐"]];
    [headSixView addSubview:recomendLabel];
    //
    UIView *lineTTTTSView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(recomendLabel.frame)+10, headSixView.frame.size.width, 1.5)];
    [lineTTTTSView setBackgroundColor:BGCOLOR];
    [headSixView addSubview:lineTTTTSView];
    //
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing:gap*2];
    [layout setMinimumInteritemSpacing:gap*2];
    //
    UICollectionView *colV=[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineTTTTSView.frame), headSixView.frame.size.width, headSixView.frame.size.height-CGRectGetMaxY(lineTTTTSView.frame)-20) collectionViewLayout:layout];
    [colV setBackgroundColor:[UIColor clearColor]];
    [colV setCollectionViewLayout:layout];
    [colV registerNib:[UINib nibWithNibName:@"GoodItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodItemCollectionViewCell"];
    colV.delegate=self;
    colV.dataSource=self;
    [headSixView addSubview:colV];

    [sv setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(headSixView.frame))];
    
    //
    //
    _bottomView=[GoodItemBottomView createBottomViewWithDelegate:self inView:self.view];
}


-(void)handleButton:(UIButton *)button{
    
    if(button.tag==100){    // 未选择尺码
        
    }else if(button.tag==101){  // 加入购物车
            
        //
        UserModel *userM=[UserModel shareInatance];
        NSMutableString *url=[NSMutableString stringWithFormat:@"http://shop.zhen.com/shopapi/cart/addProduct.json?",_productId];
        if(userM.memberid!=nil){
            [url appendString:[NSString stringWithFormat:@"memberid=%@",userM.memberid]];
        }
        [url appendString:[NSString stringWithFormat:@"&productspecid=%@&quantity=1&v=3.0",_goodItemM.skuIdsArr[currentTabSelected]]];
        [BaseRequest postWithURL:url para:nil call:^(NSData *data, NSError *error){
            if(error==nil){
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _bottomView.countLabel.text=(NSString*)((NSDictionary*)dict[@"result"])[@"cartnum"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            }
        }];
    }else{  // size
    
        [self updateSizeButton:(int)button.tag-300];
    }
    
}

-(void)updateSizeButton:(int)x{
    
    UIButton *bu=[headTwoView viewWithTag:300+currentTabSelected];
    bu.selected=false;
    UIButton *buC=[headTwoView viewWithTag:300+x];
    buC.selected=true;
    currentTabSelected=x;
    [UIView animateWithDuration:0.3 animations:^{
        bu.transform=CGAffineTransformIdentity;
        buC.transform=CGAffineTransformMakeScale(1.05, 1.05);
        // line位置
        UIView *sizeLineView=[headTwoView viewWithTag:500];
        CGRect frame=sizeLineView.frame;
        frame.origin.x=buC.frame.origin.x-3;
        frame.size.width=buC.frame.size.width+3*2;
        sizeLineView.frame=frame;
    }];
    UIButton *sizeB=[headTwoView viewWithTag:100];
    [sizeB setTitle:_goodItemM.sizeArr[x] forState:UIControlStateNormal];
}



// dele
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _goodItemM.recomendArr.count;
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
    RecomendGoodModel *itemM=(RecomendGoodModel*)_goodItemM.recomendArr[indexPath.row];
    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:itemM.msmall]];
    [cell.imgV setContentMode:UIViewContentModeScaleAspectFit];
    [cell.titleLabel setText:itemM.brandname];
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%@",itemM.price]];
    [cell.oldPriceLabel setText:[NSString stringWithFormat:@"￥%@",itemM.marketPrice]];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    GoodItemViewController *goodItemC=[[GoodItemViewController alloc]init];
    [goodItemC setProductId:((RecomendGoodModel*)_goodItemM.recomendArr[indexPath.row]).goodsId];
    [self.navigationController pushViewController:goodItemC animated:true];
}

@end
