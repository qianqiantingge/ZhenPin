//
//  RegistureViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "RegistureViewController.h"
#import "NewUserViewController.h"
#import "BaseRequest.h"
@interface RegistureViewController ()




@end

@implementation RegistureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//回到上级页面
- (IBAction)cancelBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//回到主页面
- (IBAction)returnBtn:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//获取验证码
- (IBAction)checkCodeBtn:(UIButton *)sender {
    NSString *url = [NSString stringWithFormat:@"http://ppt.zhen.com/ppt/access/exitsMobileNumber.json?mobile=%@",self.phoneNumber.text];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if ([obj[@"codeMsg"] isEqualToString:@"ok"]) {
                NSString *url1 = @"http://ppt.zhen.com/ppt/access/getValidateCode.json";
                NSDictionary *para = @{@"mobile":self.phoneNumber.text,@"type":@0};
                [BaseRequest postWithURL:url1 para:para call:^(NSData *data, NSError *error) {
                    NSDictionary *obj1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                }];
                
            }else {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"codeMsg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:alert];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:ac animated:YES completion:nil];
                });
            }
        }
    }];
}


//同意注册协议
- (IBAction)agreeBtn:(UIButton *)sender {

   
}
//跳到密码界面
- (IBAction)nextBtn:(UIButton *)sender {
    NSString *url = @"http://ppt.zhen.com/ppt/access/checkValidateCode.json";
    NSDictionary *para = @{@"mobile":self.phoneNumber.text,@"validateCode":self.checkCode.text};
    [BaseRequest postWithURL:url para:para call:^(NSData *data, NSError *error) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",obj);
        NSLog(@"%@",obj[@"result"][@"isOk"]);
        if ((Boolean)obj[@"result"][@"isOk"] == true) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NewUserViewController *newVC = [[NewUserViewController alloc] init];
                [self.navigationController pushViewController:newVC animated:YES];
            });
            
        }
    }];
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
