//
//  BrandSelectViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandSelectViewController.h"

#import "BaseRequest.h"

#import "BrandTwoModel.h"

#import "BrandTwoModel+NetWorkManager.h"

#import "Common.h"

#import "MJRefresh.h"

#import "HDManager.h"//加载指示器

#import "DescriptionCell.h"

#import "UIImageView+WebCache.h"

#import "SearchViewController.h"

#import "GoodItemViewController.h"


@interface BrandSelectViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SearchViewControllerProtocol>


@property (nonatomic,assign) NSNumber *lastPageNumber;


@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UICollectionView *collectionView;


@property(nonatomic,assign) NSInteger page;

@property (nonatomic, strong) UIView * backView;  //推荐弹出的显示小按钮的view
@property (nonatomic, strong) UIView * buttomView;  //推荐弹出下边灰色的view
@property (nonatomic, assign) UIButton * selectedBtn;  //推荐界面选中的按钮
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, strong) UIView * classView;  //分类页面
@property (nonatomic, strong) UIView * selectView;  //筛选页面

@end

@implementation BrandSelectViewController


#pragma mark - UICollectionView的懒加载
-(UICollectionView *)collectionView{
    if(_collectionView==nil){
        
        
        UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
        [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH -  gap) / 2, (SCREEN_WIDTH - gap) / 2);
        
        flowLayOut.minimumLineSpacing = gap;
        flowLayOut.minimumInteritemSpacing = 0;
        
        flowLayOut.sectionInset = UIEdgeInsetsMake(0, 5, gap, 5);
        
//        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayOut];
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64 + 50, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayOut];
        
//        _collectionView.contentInset = UIEdgeInsetsMake(2 * 64, 0, 0, 0);
        
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"DescriptionCell" bundle:nil] forCellWithReuseIdentifier:@"DescriptionCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        
        
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self loadData];
        }];
        
        
        
        //添加上拉加载更多
        //使用block
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [self loadData];
        }];
        

        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


-(NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return  _dataArray;
}






#pragma mark - 顶部按钮点击后弹出的view
//点击推荐按钮之后的view
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, 230)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_backView];
        NSArray * array = @[@"推荐排序", @"人气最高", @"最新上架", @"价格最低", @"价格最高"];
        CGFloat space = 20;
        CGFloat btnH = 20;
        for (int i = 0; i < array.count; i++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(25, space + (space + btnH) * i, 100, btnH)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [_backView addSubview:btn];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.tag = i + 10;
            if (i == 0) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.selectedBtn = btn;
            }
            [btn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _backView;
}

//推荐页面下面半透明的view
-(UIView *)buttomView {
    if (!_buttomView) {
        _buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, 114 + 230, SCREEN_WIDTH, SCREEN_HEIGHT - 94 - 220)];
        [self.view addSubview: _buttomView];
        _buttomView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.4];
    }
    return _buttomView;
}

//点击分类按钮后弹出的view
-(UIView *)classView{
    if (!_classView){
        _classView = [[UIView alloc]initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview:_classView];
        _classView.backgroundColor = [UIColor redColor];
    }
    
    
    return _classView;
}
//点击筛选按钮后弹出的view
-(UIView *)selectView{
    if (!_selectView){
        _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.view addSubview: _selectView];
        _selectView.backgroundColor = [UIColor cyanColor];
    }
    
    return _selectView;
}








- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.brandNa;
    
//    UIBarButtonSystemItemSearch
    
     UIBarButtonItem *rightMaxBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClicked)];
    self.navigationItem.rightBarButtonItem = rightMaxBt;
    

    [self loadData];
    
    [self createBtn];
    
}
#pragma mark - SearchViewController代理方法
-(void)pushVC:(UIViewController *)vc withDisMissVC:(UIViewController *)vc2{
    
    [vc2 dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)searchClicked{
    
//    NSLog(@"搜索被点击");
    
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.dele = self;

    [self presentViewController:searchVC animated:YES completion:nil ];
    
    
    
}



#pragma mark - 顶部的btn
- (void)createBtn {
//    NSArray * array = @[@"推荐", @"分类", @"筛选"];
    NSArray * array = @[@"推荐"];
//    CGFloat btnW = SCREEN_WIDTH / 3;
    CGFloat btnW = SCREEN_WIDTH;
    for (int i = 0; i < array.count; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake( btnW * i, 64, btnW, 50)];
        [self.view addSubview:btn];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = BGCOLOR;
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}




#pragma mark: - 顶部按钮的点击事件
- (void)topBtnClick: (UIButton *)sender {
    sender.selected = !sender.selected;
    
   
    switch (sender.tag) {
        case 100:{
//            NSLog(@"推荐");
            if (!sender.selected){
                self.backView.hidden = YES;
                self.buttomView.hidden = YES;
            }else{
                self.backView.hidden = NO;
                self.buttomView.hidden = NO;
            }
            self.classView.hidden = YES;
            self.selectView.hidden = YES;
            break;
        }
        case 101:
//            NSLog(@"分类");
            if (!sender.selected){
                self.classView.hidden = YES;
            }else{
                self.classView.hidden = NO;
                
            }
            self.backView.hidden = YES;
            self.buttomView.hidden = YES;
            self.selectView.hidden = YES;

            break;
            
        default:
//            NSLog(@"筛选");
            
            if (!sender.selected){
                self.selectView.hidden = YES;
            }else{
                self.selectView.hidden = NO;
            }
            self.backView.hidden = YES;
            self.buttomView.hidden = YES;
             self.classView.hidden = YES;
            
            break;
    }
}


#pragma mark - 推荐里btn的点击事件

- (void)recommendBtnClick: (UIButton *)sender {
    if (sender == self.selectedBtn) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedBtn = sender;
    
    UIButton * tuijianBtn = [self.view viewWithTag:100];
    self.selectedNumber = 0;
    if (sender.tag == 11) {
        [tuijianBtn setTitle:@"人气" forState:UIControlStateNormal];
        self.selectedNumber = 6;
        [self loadTuijianData:self.selectedNumber];
    }else if (sender.tag == 12){
        [tuijianBtn setTitle:@"最新" forState:UIControlStateNormal];
        
        self.selectedNumber = 4;
        [self loadTuijianData:self.selectedNumber];
    }else if (sender.tag == 13){
        [tuijianBtn setTitle:@"价格↑" forState:UIControlStateNormal];
        self.selectedNumber = 3;
        [self loadTuijianData:self.selectedNumber];
    }else if (sender.tag == 14){
        [tuijianBtn setTitle:@"价格↓" forState:UIControlStateNormal];
        self.selectedNumber = 2;
        [self loadTuijianData:self.selectedNumber];
    }else{
        [tuijianBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [self loadData];
    }
    self.backView.hidden = YES;
    self.buttomView.hidden = YES;
    
    
}

- (void)loadTuijianData: (NSInteger)number {
    
    [BrandTwoModel requestBrandTuijianData:self.page brandId:self.brandID order:number callBack:^(NSArray *array, NSError *error) {
        
        if (error == nil){
            
            //先移除旧数据
            if (self.page == 1){
                
                [self.dataArray removeAllObjects];
            }
            
            
            
            
            
            [self.dataArray addObjectsFromArray:array];//使用dataArray之前别忘了初始化
            
            
            
            //        NSLog(@"%@",array);
            
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }else{
            
        }
        
        [HDManager stopLoading];
        
    }];
    
}




#pragma mark - 网络请求
-(void)loadData{
//    [BaseRequest postWithURL:@"http://search.zhen.com/search/search/productSearchForSift.json?pagenumber=1&pagesize=20&noStock=1&brandid=16&v=2.0" para:nil call:^(NSData *data, NSError *error) {
//        
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        
//        
//        
//    }];
//
    
    [BrandTwoModel requestBrandTwoData:self.page brandId:self.brandID callBack:^(NSArray *array, NSNumber *lastPage, NSError *error) {
        
        
        
        [HDManager startLoading];
        if (error == nil){
            
            //先移除旧数据
            if (self.page == 1){
                
                [self.dataArray removeAllObjects];
            }
            
            
            self.lastPageNumber = lastPage;
            
            
            [self.dataArray addObjectsFromArray:array];//使用dataArray之前别忘了初始化
            
            
            
            //        NSLog(@"%@",array);
            
            [self.collectionView reloadData];
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        }
        
        [HDManager stopLoading];
        
    }];
}






#pragma mark - UICollectionView协议方法


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.dataArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"DescriptionCell";
    DescriptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    

    BrandTwoModel *model = _dataArray[indexPath.row];
    
    
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model.imageSource]];
    
    cell.titleL.text = model.productName;
    
    
    
    cell.nowPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
    
    cell.oldPrice.text = [NSString stringWithFormat:@"￥%@",model.marketPrice];
    
    
    return cell;
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((SCREEN_WIDTH - gap) / 2, ((SCREEN_HEIGHT - 64 * 2) / 2 ));
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
//    NSLog(@"@1111");
    
    GoodItemViewController *goodVC = [[GoodItemViewController alloc]init];
    
    BrandTwoModel *model = _dataArray[indexPath.row];
    goodVC.productId = [NSString stringWithFormat:@"%@",model.productId];
    [self.navigationController pushViewController:goodVC animated:YES];
    
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
