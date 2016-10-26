//
//  MSViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "MSViewController.h"
#import "Common.h"
#import "HomeModel.h"
#import "MSHeadCollectionViewCell.h"
#import "MJRefresh.h"
#import "MSContentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GoodItemViewController.h"
#import "HDManager.h"

@interface MSViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    
    NSArray *_msArr;
    UICollectionView *_headColV;
    UITableView *_contentTV;
    UILabel *tsLabel;
    UIView *_tsView;
    
    
    NSInteger currentIndex;
    Boolean first;
    NSTimer *timer;
    NSInteger oldIndex;
}
@end

@implementation MSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    first=true;
    currentIndex=-1;
    //
    [self loadData];
}

//
-(void)loadData{
    
    [HDManager startLoading];
    [MSDetailModel requestDataWithGroupId:_groupId call:^(NSArray *dataArr, NSError *error) {
        if(error==nil){
            _msArr=dataArr;
            [self createUI];
            [HDManager stopLoading];
        }
    }];
}

// UI
-(void)createUI{
    
    if(_headColV!=nil){
        [_headColV removeFromSuperview];
        [_tsView removeFromSuperview];
        [_contentTV removeFromSuperview];
        _headColV=nil;
        _tsView=nil;
        _contentTV=nil;
        timer=nil;
    }
    if(currentIndex==-1){
        //
        for(int i=0;i<_msArr.count;i++){
            
            MSDetailModel *itemM=(MSDetailModel*)_msArr[i];
            if([[NSDate date]timeIntervalSince1970]-[itemM.startTime doubleValue]>0&&[[NSDate date]timeIntervalSince1970]-[itemM.endTime doubleValue]<0){
                currentIndex=i;
                oldIndex=i;
                break;
            }
        }
    }
    //
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    self.navigationItem.title=_titl;
    [self.view setBackgroundColor:BGCOLOR];
    
    //
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [layout setMinimumLineSpacing:0];
    [layout setMinimumInteritemSpacing:0];
    //
    _headColV=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 65) collectionViewLayout:layout];
    [_headColV setBackgroundColor:[UIColor whiteColor]];
    [_headColV setShowsHorizontalScrollIndicator:false];
    [_headColV setCollectionViewLayout:layout];
    [_headColV registerNib:[UINib nibWithNibName:@"MSHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSHeadCollectionViewCell"];
    _headColV.delegate=self;
    _headColV.dataSource=self;
    [_headColV.layer setBorderColor:[UIColor colorWithWhite:0.95 alpha:1].CGColor];
    [_headColV.layer setBorderWidth:1.5];
    [self.view addSubview:_headColV];

    if(_msArr.count-currentIndex>3){
        if(currentIndex-2>0){
            [_headColV setContentOffset:CGPointMake((currentIndex-2)*65, 0)];
        }
    }else{
        [_headColV setContentOffset:CGPointMake((_msArr.count-6)*65, 0)];
    }
    //
    _tsView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headColV.frame), SCREEN_WIDTH, 40)];
    [_tsView setBackgroundColor:[UIColor whiteColor]];
    [_tsView.layer setBorderColor:[UIColor colorWithWhite:0.95 alpha:1].CGColor];
    [_tsView.layer setBorderWidth:1.5];
    [self.view addSubview:_tsView];
    //
    tsLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 250, 22)];
    [tsLabel setFont:[UIFont systemFontOfSize:13]];
    [tsLabel setTextColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [tsLabel setTextAlignment:NSTextAlignmentLeft];
    MSDetailModel *itemM=(MSDetailModel*)_msArr[currentIndex];
    [_tsView addSubview:tsLabel];
    if(currentIndex>oldIndex){
        int time=[itemM.startTime doubleValue]-[[NSDate date]timeIntervalSince1970];
        [tsLabel setText:[NSString stringWithFormat:@"抢购即将开启,距开始:%02d:%02d:%02d",time/60/60,time/60%60,time%60]];
    }else if(currentIndex<oldIndex){
        [tsLabel setText:[NSString stringWithFormat:@"抢购已结束"]];
    }else{
        int time=[itemM.endTime doubleValue]-[[NSDate date]timeIntervalSince1970];
        [tsLabel setText:[NSString stringWithFormat:@"抢购进行中,剩余时间:%02d:%02d:%02d",time/60/60,time/60%60,time%60]];
    }
    //
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:true];
    //
    _contentTV=[[UITableView alloc]initWithFrame:CGRectMake(gap/2, CGRectGetMaxY(_tsView.frame)+10, SCREEN_WIDTH-2*gap/2, SCREEN_HEIGHT-(CGRectGetMaxY(_tsView.frame)+10)) style:UITableViewStylePlain];
    [_contentTV.layer setBorderColor:[UIColor colorWithWhite:0.95 alpha:1].CGColor];
    [_contentTV.layer setBorderWidth:1.5];
    [_contentTV setDelegate:self];
    [_contentTV setDataSource:self];
    [_contentTV setBackgroundColor:[UIColor whiteColor]];
    [_contentTV setSeparatorInset:UIEdgeInsetsZero];
    [_contentTV registerNib:[UINib nibWithNibName:@"MSContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MSContentTableViewCell"];
    [self.view addSubview:_contentTV];
}



// dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((MSDetailModel*)_msArr[currentIndex]).brandArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BrandTModel *contentM=((MSDetailModel*)_msArr[currentIndex]).brandArr[indexPath.row];
    
    MSContentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MSContentTableViewCell"];
//    cell.dele=self;
    [cell.photoImgV sd_setImageWithURL:[NSURL URLWithString:contentM.msmall]];
    [cell.infoLabel setText:[NSString stringWithFormat:@"%@/%@",contentM.brandname,contentM.productName]];
    if([contentM.stock intValue]==0 || currentIndex<oldIndex){
        [cell.buyButton setTitle:@"已抢光" forState:UIControlStateNormal];
        [cell.buyButton setUserInteractionEnabled:false];
        [cell.buyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.buyButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [cell.countLabel setHidden:true];
    }else if([contentM.stock intValue]<10){
        [cell.countLabel setText:[NSString stringWithFormat:@"仅剩%@件",contentM.stock]];
    }else{
        [cell.countLabel setHidden:true];
    }
    [cell.priceLabel setText:[NSString stringWithFormat:@"￥%@",contentM.premiumPrice]];
    [cell.oldPriceLabel setText:[NSString stringWithFormat:@"原价:￥%@",contentM.marketPrice]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    BrandTModel *contentM=((MSDetailModel*)_msArr[currentIndex]).brandArr[indexPath.row];
    GoodItemViewController *goodItemC=[[GoodItemViewController alloc]init];
    [goodItemC setProductId:contentM.productId];
    [self.navigationController pushViewController:goodItemC animated:true];
}



// dele
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _msArr.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(65, 65);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MSHeadCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MSHeadCollectionViewCell" forIndexPath:indexPath];
    
    MSDetailModel *itemM=(MSDetailModel*)_msArr[indexPath.row];
    //
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[itemM.startTime doubleValue]];
    NSDateFormatter *famt=[[NSDateFormatter alloc]init];
    famt.dateFormat=@"HH:mm";
    NSString *timeStr=[famt stringFromDate:date];
    //
    NSString *tagString;
    if([[NSDate date]timeIntervalSince1970]-[itemM.endTime doubleValue]>0){
        tagString=@"已结束";
    }else if([[NSDate date]timeIntervalSince1970]-[itemM.startTime doubleValue]<0){
        tagString=@"即将开始";
    }else{
        tagString=@"抢购中";
        if(first){
            currentIndex=indexPath.row;
            [_contentTV reloadData];
            first=false;
        }
    }
    if(currentIndex==indexPath.row&&!first){
        
        [cell.timeLabel setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
        [cell.timeLabel setTextColor:[UIColor redColor]];
        [cell.tagLabel setTransform:CGAffineTransformMakeScale(1.12, 1.12)];
        [cell.tagLabel setTextColor:[UIColor redColor]];
        [cell.dotView setBackgroundColor:[UIColor redColor]];
        [cell.dotView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    }else{
        [cell.timeLabel setTransform:CGAffineTransformIdentity];
        [cell.timeLabel setTextColor:[UIColor grayColor]];
        [cell.tagLabel setTransform:CGAffineTransformIdentity];
        [cell.tagLabel setTextColor:[UIColor grayColor]];
        [cell.dotView setBackgroundColor:[UIColor grayColor]];
        [cell.dotView setTransform:CGAffineTransformIdentity];
    }
    [cell.timeLabel setText:timeStr];
    [cell.tagLabel setText:tagString];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    currentIndex=indexPath.row;
    [collectionView reloadData];
    //
    _groupId=((MSDetailModel*)_msArr[indexPath.row]).groupId;
    [self loadData];
}



-(void)timeChange{
    
    MSDetailModel *itemM=(MSDetailModel*)_msArr[currentIndex];
    int time=0;
    if(currentIndex>oldIndex){
        time=[itemM.startTime doubleValue]-[[NSDate date]timeIntervalSince1970];
        [tsLabel setText:[NSString stringWithFormat:@"抢购即将开启,距开始:%02d:%02d:%02d",time/60/60,time/60%60,time%60]];
    }else if(currentIndex<oldIndex){
        [tsLabel setText:[NSString stringWithFormat:@"抢购已结束"]];
    }else{
        time=[itemM.endTime doubleValue]-[[NSDate date]timeIntervalSince1970];
        [tsLabel setText:[NSString stringWithFormat:@"抢购进行中,剩余时间:%02d:%02d:%02d",time/60/60,time/60%60,time%60]];
    }
    
    if(time==0){
        // 未处理
        
    }
}
@end
