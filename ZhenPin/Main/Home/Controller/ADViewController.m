//
//  ADViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "ADViewController.h"
#import "Common.h"
#import "HDManager.h"

@interface ADViewController ()<UIWebViewDelegate>{

    UIWebView *webView;
}
@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=false;
    //
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithWhite:0.1 alpha:1]];
    self.navigationItem.title=_titl;
    //
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webView.delegate=self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    [self.view addSubview:webView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    [HDManager startLoading];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [HDManager stopLoading];
}


@end
