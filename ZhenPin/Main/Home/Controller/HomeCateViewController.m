//
//  HomeCateViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HomeCateViewController.h"
#import "HomeModel.h"
#import "HomeViewController.h"
#import "HomeTViewController.h"
#import "Common.h"
#import "MJRefresh.h"
#import "TitleBar.h"
#import "SearchViewController.h"




@interface HomeCateViewController ()<TitleBarProtocol,HomeCateViewControllerProtocol,SearchViewControllerProtocol>{
    
    NSMutableArray *_vcArr;
    NSMutableArray *_titleArr;
    TitleBar *_myTabV;
}

@end

@implementation HomeCateViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor=BAR_TINTCOLOR;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.95 alpha:1]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=false;
    [self initData];
    [self setNavBar];
}
// navBar
-(void)setNavBar{
    //
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 25)];
    [leftButton setTitle:@"珍品" forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [leftButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //
    UIButton *searchButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 25)];
    [searchButton setBackgroundColor:[UIColor colorWithRed:160/255.0 green:50/255.0 blue:50/255.0 alpha:1]];
    [searchButton setTitle:@"iphone7" forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [searchButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    [searchButton.layer setCornerRadius:10.0];
    [searchButton.layer setMasksToBounds:true];
    [searchButton setTag:120];
    [searchButton addTarget:self action:@selector(handleSButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView=searchButton;
    //
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(handleSButton:)];
}
// data
-(void)initData{
    
    _vcArr=[[NSMutableArray alloc]init];
    [TitleModel requestTitleData:^(NSArray *titleArr, NSError *error) {
    
        for(int i=0;i<titleArr.count;i++){
            if(i==0){
                HomeViewController *homeC=[[HomeViewController alloc]init];
                homeC.title=((TitleModel*)titleArr[i]).name;
                homeC.pageId=((TitleModel*)titleArr[i]).id;
                homeC.dele=self;
                [_vcArr addObject:homeC];
            }else{
                HomeTViewController *homeTC=[[HomeTViewController alloc]init];
                homeTC.title=((TitleModel*)titleArr[i]).name;
                homeTC.pageId=((TitleModel*)titleArr[i]).id;
                homeTC.dele=self;
                [_vcArr addObject:homeTC];
            }
        }
        
        _myTabV=[TitleBar TitleBarWithFrame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) vcArr:_vcArr dele:self];
        [self.view bringSubviewToFront:_myTabV];
        [self.view addSubview:_myTabV];
    }];
}


// search
-(void)handleSButton:(UIButton*)button{
    
 
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    searchVC.dele=self;
    [self presentViewController:searchVC animated:false completion:nil];
}

// delegate
-(void)selectedWithIndex:(int)index{
    
    id vc=_vcArr[index];
    if(index==0){
        [((HomeViewController*)vc).contentTV.mj_header beginRefreshing];
    }else{
        [((HomeTViewController*)vc).contentTV.mj_header beginRefreshing];
    }
}


// dele
-(void)pushVC:(UIViewController*)vc{

    vc.hidesBottomBarWhenPushed=true;
    [self.navigationController pushViewController:vc animated:false];
}
// dele
-(void)pushVC:(UIViewController *)vc withDisMissVC:(UIViewController *)vc2{

    [vc2 dismissViewControllerAnimated:false completion:nil];
    [self pushVC:vc];
}

@end
