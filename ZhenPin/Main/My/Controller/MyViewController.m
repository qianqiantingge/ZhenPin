//
//  MyViewController.m
//  SSTGoods
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "setUpViewController.h"
#import "UserModel.h"
#import "BaseRequest.h"
#import "ADViewController.h"
#import "OrderViewController.h"
@interface MyViewController () <UIScrollViewDelegate>
{
    UIScrollView *scrollview;
    UIImageView * _topImgV;
    CGFloat _topImageVNomalHeight;
    UIButton *button3;
    UILabel *username;
    UIButton *myBtn;
    UIView *view;
    UIButton *setUp;
    LoginViewController *love;
    //第一模块titleArray
    NSArray *orderArray;
}

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    love = [[LoginViewController alloc] init];
    scrollview = [[UIScrollView alloc] init];
    orderArray = @[@"全部订单",@"待付款",@"待收货",@"待评价",@"退换货"];
    [self creatUI];
    
}

-(void)creatUI {
    CGFloat space = 30;
    CGFloat space2 = (self.view.frame.size.width - (2 * space) - 100 - 70) / 2;
    //下面视图边界值
    CGFloat space3 = 5;
    CGFloat space4 = 90;

    scrollview.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    scrollview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    
    UIImage *image = [UIImage imageNamed:@"my.jpg"];
    _topImgV = [[UIImageView alloc] initWithImage:image];
    _topImgV.tag = 100;
    _topImageVNomalHeight = 200;
    _topImgV.frame = CGRectMake(0, -200, self.view.frame.size.width, 200);
    [scrollview addSubview:_topImgV];
    scrollview.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    scrollview.contentOffset =  CGPointMake(0, -200);
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200)];
    setUp = [[UIButton alloc] initWithFrame:CGRectMake(space, 80, 50, 50)];
    setUp.layer.cornerRadius = 25;
    setUp.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:205/255.0 alpha:1];
    [setUp addTarget:self action:NSSelectorFromString(@"setup") forControlEvents:UIControlEventTouchUpInside];
    setUp.layer.masksToBounds = YES;
    [setUp setImage:[[UIImage imageNamed:@"20"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    [view addSubview:setUp];
    
    myBtn = [[UIButton alloc] initWithFrame:CGRectMake(space + 50 + space2, 60, 70, 70)];
    [myBtn setImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
    myBtn.layer.cornerRadius = 35;
    myBtn.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:205/255.0 alpha:0.6];
    myBtn.layer.masksToBounds = YES;
    [view addSubview:myBtn];
    
    username = [[UILabel alloc] initWithFrame:CGRectMake(space + 40 + space2, 140, 110, 23)];
    username.textColor = [UIColor whiteColor];
    username.font = [UIFont systemFontOfSize:12];
    [view addSubview:username];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(space + 50 + space2 * 2 + 70, 80, 50, 50)];
    [button2 setImage:[UIImage imageNamed:@"21"] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:205/255.0 alpha:1];
    button2.layer.cornerRadius = 25;
    button2.layer.masksToBounds = YES;
    [button2 addTarget:self action:NSSelectorFromString(@"messageClick") forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    button3 = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80) / 2, myBtn.frame.origin.y + 70 + 20, 80, 21)];
    button3.backgroundColor = [UIColor colorWithRed:172/255.0 green:154/255.0 blue:142/255.0 alpha:1];
    [button3 setTitle:@"登录/注册" forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize:12];
    button3.layer.cornerRadius = 10;
    button3.tag = 1000;
    [button3 addTarget:self action:NSSelectorFromString(@"LoginClick") forControlEvents:UIControlEventTouchUpInside];
    button3.layer.masksToBounds = YES;
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:button3];
    
    [scrollview addSubview:view];
    
    //头部视图下面布局
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(space3, 5, self.view.frame.size.width - 2 * space3, 100)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.cornerRadius = 8;
    view1.clipsToBounds = YES;
    for (int i = 0; i <= 4; i++) {
        
        CGFloat btnW = (view1.frame.size.width - 40 * 5 - 2 * 10) / 4;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * (btnW + 40) + 10, (view1.frame.size.height - btnW) / 2 - 10, 40, 40)];
        [btn setTitle:orderArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1]] forState:UIControlStateNormal];
        btn.tag = i + 1;
        btn.titleEdgeInsets = UIEdgeInsetsMake(btnW + 25, 0, 0, 0);
        [btn addTarget:self action:NSSelectorFromString(@"orderClick:") forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview: btn];
    }
    [scrollview addSubview:view1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(space3, view1.frame.origin.y + view1.frame.size.height + 5, self.view.frame.size.width - 2 * space3, 100)];
    view2.backgroundColor = [UIColor whiteColor];
    view2.layer.cornerRadius = 8;
    view2.clipsToBounds = YES;
    for (int i = 0; i <= 4; i++) {
        NSArray *array = @[@"余额",@"优惠券",@"积分",@"礼品卡",@"收益"];
        CGFloat btnW = (view1.frame.size.width - 40 * 5 - 2 * 10) / 4;
        UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(i * (btnW + 40) + 10, (view1.frame.size.height - btnW) / 2 - 10, 40, 40)];
        [btn1 setTitle:array[i] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:10];
        btn1.tag = i + 1 + 5;
        [btn1 addTarget:self action:NSSelectorFromString(@"VIPClick:") forControlEvents:UIControlEventTouchUpInside];
        [btn1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i + 1 + 5]] forState:UIControlStateNormal];
        btn1.titleEdgeInsets = UIEdgeInsetsMake(btnW + 25, 0, 0, 0);
        [view2 addSubview: btn1];
    }
    [scrollview addSubview:view2];
    
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(space3, view2.frame.origin.y + view2.frame.size.height + 5, self.view.frame.size.width - 2 * space3, 200)];
    view3.backgroundColor = [UIColor whiteColor];
    view3.layer.cornerRadius = 8;
    view3.clipsToBounds = YES;
    for (int k = 0; k < 8; k++) {
        
        NSArray *array = @[@"我的收藏",@"我的足迹",@"珍品会员",@"邀请返利",@"珍会花",@"地址管理",@"帮助中心",@"意见反馈"];
        CGFloat btnW = (view1.frame.size.width - 40 * 4 - 2 * 20) / 3;
        UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake((k % 4) * (btnW + 40) + 20, (k / 4) * (view3.frame.size.height) / 2 + 10, 40, 40)];
        [btn2 setTitle:array[k] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn2.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",k + 1 + 10]] forState:UIControlStateNormal];
        btn2.tag = k + 1 + 10;
        [btn2 addTarget:self action:NSSelectorFromString(@"myCenter:") forControlEvents:UIControlEventTouchUpInside];
        btn2.titleEdgeInsets = UIEdgeInsetsMake(btnW + 25, 0, 0, 0);
        [view3 addSubview: btn2];
    }
    [scrollview addSubview:view3];
    
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(space4, view3.frame.origin.y + view3.frame.size.height + 20, 20, 20)];
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"19"] forState:UIControlStateNormal];
    [scrollview addSubview:phoneBtn];
    
    UIButton *telephoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.frame.origin.x + phoneBtn.frame.size.width, phoneBtn.frame.origin.y, self.view.frame.size.width - 2 * space4 - phoneBtn.frame.size.width - 5, 20)];    telephoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [telephoneBtn setTitle:@"时尚服务热线:400-009-6666" forState:UIControlStateNormal];
    [telephoneBtn setTitleColor:[UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1] forState:UIControlStateNormal];
    [telephoneBtn addTarget:self action:NSSelectorFromString(@"callPhone") forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:telephoneBtn];
}
//设置
-(void)setup {
    setUpViewController *setupVC = [[setUpViewController alloc] init];
    self.navigationController.navigationBar.hidden = NO;
    setupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setupVC animated:YES];
}
//登录
-(void)LoginClick {
    love.delegate = self;
    [self.navigationController pushViewController:love animated:YES];
}
//信息点击事件
-(void)messageClick {
    UserModel *model = [UserModel shareInatance];
    if (model.username == nil) {
        [self.navigationController pushViewController:love animated:YES];
    }else {
    }
}
//拨打热线
-(void)callPhone {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"珍品时尚顾问竭诚为您服务" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拨打 400-009-6666" style:UIAlertActionStyleDestructive handler:nil];
    [ac addAction:action1];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:action];
    [self presentViewController:ac animated:YES completion:nil];
}

//第一模块点击事件
-(void)orderClick:(UIButton *)btn {
    OrderViewController *orderVC = [[OrderViewController alloc] init];
    
    UserModel *model = [UserModel shareInatance];
    switch (btn.tag) {
        case 6:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:orderVC animated:YES];
                orderVC.navigationItem.title = orderArray[btn.tag - 1];
            }
            break;
        case 7:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:orderVC animated:YES];
                orderVC.navigationItem.title = orderArray[btn.tag - 1];
            }
            break;
        case 8:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:orderVC animated:YES];
                orderVC.navigationItem.title = orderArray[btn.tag - 1];
            }
            break;
        case 9:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:orderVC animated:YES];
                orderVC.navigationItem.title = orderArray[btn.tag - 1];
            }
            break;
        default:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
                self.navigationController.navigationBar.hidden = NO;
                [self.navigationController pushViewController:orderVC animated:YES];
                orderVC.navigationItem.title = orderArray[btn.tag - 1];
            }
            break;
    }
}

//第二模块点击事件
-(void)VIPClick:(UIButton *)btn {
    
    UserModel *model = [UserModel shareInatance];
    switch (btn.tag) {
        case 1:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
            }
            break;
        case 2:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
            }
            break;
        case 3:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
            }
            break;
        case 4:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
            }
            break;
        default:
            if (model.username == nil) {
                [self.navigationController pushViewController:love animated:YES];
            }else {
            }
            break;
    }

}

//第三模块点击事件
-(void)myCenter:(UIButton *)btn {
    UserModel *model = [UserModel shareInatance];
   
    if (btn.tag == 11) {
        
        if (model.username == nil) {
            [self.navigationController pushViewController:love animated:YES];
        }else {
            NSString *urll = @"http://h5.zhen.com/?c=APP_my&c=collect&fromzp=sign";
            ADViewController *advc = [[ADViewController alloc] init];
            advc.hidesBottomBarWhenPushed = YES;
            advc.url = urll;
            advc.titl = @"我的收藏";
            [self.navigationController pushViewController:advc animated:YES];
        }
    }else if(btn.tag == 17) {
        
        NSString *urll = @"http://h5.zhen.com/index.php?c=APP_help&a=help";
        ADViewController *advc = [[ADViewController alloc] init];
        advc.hidesBottomBarWhenPushed = YES;
        advc.url = urll;
        advc.titl = @"帮助中心";
        [self.navigationController pushViewController:advc animated:YES];
    }else if (btn.tag == 15) {
        if (model.username == nil) {
            [self.navigationController pushViewController:love animated:YES];
            
        }else {
            NSString *urll = [NSString stringWithFormat:@"http://h5.zhen.com/?c=APP_my&a=zhenhuihua&fromzp=sign&memberid=%@&token=%@",model.memberid,model.token];
            ADViewController *advc = [[ADViewController alloc] init];
            advc.url = urll;
            advc.titl = @"珍会花";
            advc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:advc animated:YES];
        }
    }else if (btn.tag == 13) {
        if (model.username == nil) {
            
            [self.navigationController pushViewController:love animated:YES];
        }else {
            NSString *urll = @"http://h5.zhen.com/?c=APP_membercenter";
            ADViewController *advc = [[ADViewController alloc] init];
            advc.url = urll;
            advc.titl = @"珍品会员";
            advc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:advc animated:YES];
        }
    }else if (btn.tag == 12) {
        if (model.username == nil) {
            [self.navigationController pushViewController:love animated:YES];
        }else {
            
        }
    }else if (btn.tag == 14) {
        if (model.username == nil) {
            [self.navigationController pushViewController:love animated:YES];
        }else {
            
        }
    }else if (btn.tag == 16) {
        if (model.username == nil) {
            [self.navigationController pushViewController:love animated:YES];
        }else {
            
        }
    }else if (btn.tag == 18) {
        if (model.username == nil) {
            [self.navigationController pushViewController:love animated:YES];
        }else {
            
        }
    }
}
//协议方法
-(void)labelTest:(NSString *)phoneNum {
    username.text = phoneNum;
   UILabel *vip = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 80) / 2, myBtn.frame.origin.y + 80 + 20, 80, 21)];
    vip.backgroundColor = [UIColor colorWithRed:172/255.0 green:154/255.0 blue:142/255.0 alpha:1];
    vip.textColor = [UIColor whiteColor];
    vip.font = [UIFont systemFontOfSize:12];
    vip.layer.cornerRadius = 10;
    vip.layer.masksToBounds = YES;
    vip.textAlignment = NSTextAlignmentCenter;
    vip.text = @"普通会员";
    vip.userInteractionEnabled = NO;
    [button3 removeFromSuperview];
    [view addSubview:vip];
}

#pragma mark - scrollVIew 代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取y方向偏移量
    CGFloat offSetY = scrollView.contentOffset.y;
    //判断执行图片的放大和缩小;只有offSetY小于-_topImgVNomalHeight时候，才进行缩放。
    if (offSetY < -_topImageVNomalHeight) {
        CGRect rect = _topImgV.frame;
        CGFloat rate = rect.size.width / rect.size.height;
        //offSetY是个<0的值
        rect.size.height = -offSetY;
        rect.size.width = (-offSetY) * rate;
        rect.origin.y = offSetY;
        rect.origin.x = -((-offSetY) * rate - self.view.frame.size.width)/2;
        //设置imgView的frame
        _topImgV.frame = rect;
    }
}
@end
