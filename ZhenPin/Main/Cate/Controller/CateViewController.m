//
//  CateViewController.m
//  SSTGood
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "CateViewController.h"

//代理方第一步：遵守协议
@interface CateViewController ()<UITableViewDelegate, UITableViewDataSource, TableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, SearchViewControllerProtocol>

@property (nonatomic, strong) NSMutableArray * cateArray;
@property (nonatomic, strong) NSMutableArray * cateChildArray;
@property (nonatomic, strong) NSMutableArray * titleNameArray;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation CateViewController

- (NSMutableArray *)cateArray {
    if (!_cateArray) {
        _cateArray = [[NSMutableArray alloc] init];
    }
    return _cateArray;
}

- (NSMutableArray *)cateChildArray {
    if (!_cateChildArray) {
        _cateChildArray = [[NSMutableArray alloc] init];
    }
    return _cateChildArray;
}

- (NSMutableArray *)titleNameArray {
    if (!_titleNameArray) {
        _titleNameArray = [[NSMutableArray alloc] init];
    }
    return _titleNameArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5, 84, SCREEN_WIDTH / 5 * 4, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerNib:[UINib nibWithNibName:@"tableViewCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createSearchBtn];    
    [self requestData];
    [self requestCateData:@2];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = BAR_TINTCOLOR;
}

- (void)createSearchBtn {
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 30, 25)];
    btn.layer.cornerRadius = 15;
    btn.clipsToBounds = YES;
    self.navigationItem.titleView = btn;
    btn.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4];
    [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [btn setTitle:@"iPhone7" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)searchBtnClick {
    SearchViewController * svc = [[SearchViewController alloc] init];
    svc.dele = self;
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    SearchViewController * svc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)createUI {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH / 5, SCREEN_HEIGHT - 64 - 49)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, 50 * self.cateArray.count);
    [self.view addSubview:scrollView];
    for (int i = 0; i < self.cateArray.count; i++) {
        CateModel * model = self.cateArray[i];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50 * i, SCREEN_WIDTH / 5, 49)];
        [btn setTitle:model.categoryName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i + 10;
        btn.backgroundColor = BGCOLOR;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        
        if (i == 0) {
            selectedBtn = btn;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}


- (void)btnClick: (UIButton *)sender{
    if (sender == selectedBtn) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor whiteColor];
    [selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectedBtn.backgroundColor = BGCOLOR;
    selectedBtn = sender;
    
    [self.titleNameArray removeAllObjects];
    [self.cateChildArray removeAllObjects];
    CateModel * model = self.cateArray[sender.tag - 10];
    [self requestCateData:model.categoryId];
}

- (void)requestData{
    NSString * urlStr = @"http://home.zhen.com/home/categoryPage/homeCategoryLevel1.json";
    NSDictionary * para = @{@"level": @3};
    [HDManager startLoading];
    [BaseRequest postWithURL:urlStr para:para call:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * result = dict[@"result"];
            NSArray * categoryArray = result[@"category"];
            for (int i = 0; i<categoryArray.count;i++) {
                [self.cateArray addObject:[CateModel modelWith:categoryArray[i]]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self createUI];
                [self.tableView reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@", error);
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"网络请求失败" message:@"请检查网络" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [ac addAction:action];
                [self presentViewController:ac animated:YES completion:nil];
            });
        }
    }];
    [HDManager stopLoading];
}

- (void)requestCateData: (NSNumber *) cateId{
    NSString * detailsUrl = @"http://home.zhen.com/home/categoryPage/homeCategoryByParentId.json";
    NSDictionary * detailsDic = @{@"v": @2.0,@"parentCateID": cateId};
    [HDManager startLoading];
    [BaseRequest postWithURL:detailsUrl para:detailsDic call:^(NSData *data, NSError *error) {
        if (error == nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary * result = dict[@"result"];
            NSArray * cateChild = result[@"CategoryChildren"];
            for (int i = 0; i < cateChild.count; i++) {
                NSString * name = [cateChild[i] valueForKey:@"gatherName"];
                [self.titleNameArray addObject:name];
                NSArray * gtChilds = [cateChild[i] valueForKey:@"gtCategoryChildrens"];
                NSMutableArray *arr = [NSMutableArray array];
                for (int j = 0; j < gtChilds.count; j++) {
                    [arr addObject:[CateChildModel modelWith:gtChilds[j]]];
                }
                [self.cateChildArray addObject:arr];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                NSLog(@"%@", error);
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"网络请求失败" message:@"请检查网络" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [ac addAction:action];
                [self presentViewController:ac animated:YES completion:nil];
                
            });
        }
    }];
    [HDManager stopLoading];
}

#pragma mark: SearchViewControllerProtocol 协议方法
- (void)pushVC:(UIViewController *)vc withDisMissVC:(UIViewController *)vc2 {
    [vc2 dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: TableViewDelegat 协议方法
- (void)backIndex:(NSIndexPath *)indexPath other:(NSInteger)indexPathSection {
    NSArray * array = self.cateChildArray[indexPathSection];
    CateChildModel * model = array[indexPath.item];
    DetailsViewController * dvc = [[DetailsViewController alloc] init];
    dvc.titleName = model.categoryName;
    dvc.baseID = model.baseCategory;
    dvc.gender = model.gender;
    dvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dvc animated:YES];
}

//MARK: UITableView 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cateChildArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.dataArr = self.cateChildArray[indexPath.section];
    cell.indexSection = indexPath.section;
    [cell.collectionView reloadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = self.cateChildArray[indexPath.section];
    if (array.count % 3 == 0) {
        return array.count / 3 * (SCREEN_WIDTH / 5 + 30) + 80;
    }
    return (array.count / 3 + 1) * (SCREEN_WIDTH / 5 + 30) + 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 5 * 4, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    NSString * str = [NSString stringWithFormat:@"—————— %@ ——————", self.titleNameArray[section]];
    label.text = str;
    label.font = [UIFont systemFontOfSize:14];
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

@end
