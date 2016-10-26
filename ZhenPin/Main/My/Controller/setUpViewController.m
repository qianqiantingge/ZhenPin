//
//  setUpViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "setUpViewController.h"
#import "Common.h"
#import "AboutZhenPinViewController.h"
@interface setUpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableVieww;
    NSMutableArray *dataArr;
}
@end

@implementation setUpViewController

- (void)viewDidLoad {
    //退出登录 btn x方向间隙
    CGFloat space = 50;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.se
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    UIBarButtonItem * lbtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(popView)];
    self.navigationItem.leftBarButtonItem = lbtn;
    self.navigationItem.title = @"设置";
    tableVieww = [[UITableView alloc] initWithFrame:CGRectMake(5, 64 + 8, SCREEN_WIDTH - 10, SCREEN_HEIGHT / 3 * 2) style:UITableViewStyleGrouped];
    tableVieww.backgroundColor = [UIColor whiteColor];
    tableVieww.delegate = self;
    tableVieww.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = false;
    tableVieww.showsVerticalScrollIndicator = NO;
    tableVieww.layer.cornerRadius = 10;
    tableVieww.layer.masksToBounds = YES;
    [self.view addSubview:tableVieww];
    NSArray *arr = @[@[@"消息通知提醒",@"商品详情页弹幕",@"清除本地缓存"],@[@"给我们评分鼓励下吧",@"推荐珍品给好友",@"关于珍品"]];
    dataArr = [NSMutableArray arrayWithArray:arr];
    
    
    //退出登录
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (SCREEN_WIDTH - 2*space)) / 2, SCREEN_HEIGHT - 50, SCREEN_WIDTH - 2*space, 40)];
    button.backgroundColor = [UIColor colorWithRed:226/225.0 green:0 blue:26/255.0 alpha:1];
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:NSSelectorFromString(@"cancellLogin") forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)popView{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
//取消登录点击事件
-(void)cancellLogin {
    
}

//获取缓存数据方法
-(CGFloat)floderSizeAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        return size / 1024.0 / 1024.0;
    }
    return 0;
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
#pragma mark - tableView 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qqq"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qqq"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            NSString *path = NSHomeDirectory();
            NSString *pathh = [path stringByAppendingPathComponent:@"Library/Caches"];
            CGFloat huanCunNumber = [self floderSizeAtPath:pathh];
            
            UILabel *huanCunL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2*5 - 10-60, 10, 60, 24)];
            huanCunL.text = [NSString stringWithFormat:@"%0.2fMB",huanCunNumber];
            huanCunL.font = [UIFont systemFontOfSize:12];
            huanCunL.textColor = [UIColor grayColor];
            huanCunL.tag = 20;
            [cell.contentView addSubview:huanCunL];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            UILabel *aboutZhenPinL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 2*5 - 10-60, 10, 60, 24)];
            aboutZhenPinL.text = @"V3.3";
            aboutZhenPinL.font = [UIFont systemFontOfSize:12];
            aboutZhenPinL.textColor = [UIColor grayColor];
            [cell.contentView addSubview:aboutZhenPinL];
        }
    }
    cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableVieww deselectRowAtIndexPath:indexPath animated:YES];
    //清除缓存
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"清除后，图片等信息需重新下载，确认清除?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString *path = NSHomeDirectory();
                NSString *pathh = [path stringByAppendingPathComponent:@"Library/Caches"];
                NSFileManager *fileManger = [NSFileManager defaultManager];
                if ([fileManger fileExistsAtPath:pathh]) {
                    NSArray *childrenFiles = [fileManger subpathsAtPath:pathh];
                    for (NSString *fileName in childrenFiles) {
                        NSString *absolutePath = [pathh stringByAppendingPathComponent:fileName];
                        [fileManger removeItemAtPath:absolutePath error:nil];
                    }
                }
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UILabel *label = [cell.contentView viewWithTag:20];
                
                CGFloat huanCunNumber = [self floderSizeAtPath:path];
                label.text = [NSString stringWithFormat:@"%2.fMB",huanCunNumber];
                
            }];
            [ac addAction:action1];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:action];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            AboutZhenPinViewController *abVC = [[AboutZhenPinViewController alloc] init];
            [self.navigationController pushViewController:abVC animated:YES];
        }
    }
}

@end
