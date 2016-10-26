//
//  LoginViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistureViewController.h"
#import "BaseRequest.h"
#import "NSString+Hashing.h"
#import "UserModel.h"
#import "MyViewController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImge;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImage;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userNameTF.leftView = self.userImge;
    self.userNameTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTF.leftView = self.passwordImage;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.secureTextEntry = YES;
}

- (IBAction)cancelBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)registBtn:(UIButton *)sender {
    RegistureViewController *regVC = [[RegistureViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}


- (IBAction)loginBtn:(UIButton *)sender {
    UserModel *usere = [UserModel shareInatance];
    NSString *url = @"http://ppt.zhen.com/ppt/access/onLogin.json";
    
    NSDictionary *para = @{@"apptype":@0,@"channel":@3,@"isuname":@3,@"password":[self.passwordTF.text MD5Hash].lowercaseString,@"username":self.userNameTF.text};
    
    NSLog(@"%@",[self.passwordTF.text MD5Hash].lowercaseString);
    [BaseRequest postWithURL:url para:para call:^(NSData *data, NSError *error) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *codeMsg = obj[@"codeMsg"];
        if (error == nil){
            if (obj[@"result"] == nil) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:codeMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:alert];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [self presentViewController:ac animated:YES completion:nil];
                });
            }else {
               
                usere.username = obj[@"result"][@"username"];
                usere.token = obj[@"result"][@"access_token"];
                usere.memberid = obj[@"result"][@"memberid"];
                usere.mobile = obj[@"result"][@"mobile"];
                
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:codeMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [ac addAction:alert];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate labelTest:obj[@"result"][@"username"]];
                    [self presentViewController:ac animated:YES completion:nil];
                    
                });
                
            }
           
        }
        
    }];
    
    
}


- (IBAction)wechatLoginBtn:(UIButton *)sender {
}


- (IBAction)securityWrite:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"安全输入1"] forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = NO;
    }else {
        [sender setImage:[UIImage imageNamed:@"安全输入2"] forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = YES;
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
