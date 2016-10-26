//
//  NewUserViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "NewUserViewController.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//返回注册界面
- (IBAction)registureBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
