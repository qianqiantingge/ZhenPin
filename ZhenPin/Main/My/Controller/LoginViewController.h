//
//  LoginViewController.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginViewControllerDelegate <NSObject>
-(void)labelTest:(NSString *)phoneNum;
@end
@interface LoginViewController : UIViewController
@property (nonatomic,weak) id <LoginViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end
