//
//  BrandViewController.m
//  SSTGood
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandViewController.h"
#import "BrandOneModel+NetWorkManager.h"


#import "MyCell.h"

#import "BaseRequest.h"

#import "UIImageView+WebCache.h"

#import "Common.h"

#import "BrandSelectViewController.h"

#import "MJRefresh.h"

#import "HDManager.h"//加载指示器


@interface BrandViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>





@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *btn;


@property (nonatomic,assign) BOOL yes;


@property (nonatomic,strong) NSMutableArray *listarray;


@property(nonatomic,assign) NSInteger page;



@end

@implementation BrandViewController

-(NSMutableArray *)dataArray{
    if (!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return  _dataArray;
}



-(UICollectionView *)collectionView{
    if(_collectionView==nil){
        
        
        UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc]init];
        [flowLayOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayOut.itemSize = CGSizeMake((SCREEN_WIDTH - (4 * gap)) / 3, (SCREEN_WIDTH - (4 * gap)) / 3);
        flowLayOut.minimumLineSpacing = gap;
        flowLayOut.minimumInteritemSpacing = 0;
        
        flowLayOut.sectionInset = UIEdgeInsetsMake(gap, gap, 0, gap);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayOut];
        _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        _collectionView.backgroundColor = BGCOLOR;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self loadData];
        }];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
-(UITableView *)tableView{
    
    
    if (_tableView==nil){
        _tableView = [[UITableView alloc]initWithFrame:SCREEN_BOUNDS style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.sectionIndexColor = [UIColor grayColor];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = BAR_TINTCOLOR ;
    
    self.page = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//关闭自动下沉
    
    _yes = NO;
    
    if (!_yes){
        
        [self loadData];
        
    }
    [self createBtn];
    

    
}

#pragma mark - 设置右上角按钮
-(void)createBtn{
    
    _btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    [_btn setTitle:@"A-Z" forState:UIControlStateNormal];
    
    
    _btn.titleLabel.font = [UIFont systemFontOfSize:25];
    
    [_btn addTarget:self action:@selector(BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *bItem = [[UIBarButtonItem alloc]initWithCustomView:_btn];
    
    self.navigationItem.rightBarButtonItem = bItem;
}

-(void)BtnClicked{
    
    //    NSLog(@"1111");
    _yes = !_yes;
    
    if(_yes){
        
        [self loadBrandData];
        
        [_btn setTitle:@"热门品牌" forState:UIControlStateNormal];
        
        _btn.titleLabel.font = [UIFont systemFontOfSize:20];
        
        //        _collectionView.hidden = YES;
        _tableView.hidden = NO;
        
    }else{
        
        [self loadData];
        //        _collectionView.hidden = NO;
        
        _tableView.hidden = YES;
        
        [_btn setTitle:@"A-Z" forState:UIControlStateNormal];
        
        
        _btn.titleLabel.font = [UIFont systemFontOfSize:25];
        
    }
    
}
#pragma mark - 获取网络数据
-(void)loadData{
    
    [BrandOneModel requestCateData:^(NSArray *brand, NSError *error) {
        [HDManager startLoading];
        if (error == nil){
            //先移除旧数据
            if (self.page == 1){
                
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:brand];
            //           NSLog(@"%@",_dataArray);
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }
        
        [HDManager stopLoading];
        
    }];
}

//获取列表数据
-(void)loadBrandData{
    //    [self.tableView reloadData];
    [HDManager startLoading];
    [BrandOneModel requestBrandData:^(NSMutableArray *list, NSError *error) {
        if (error == nil){
            self.listarray = list;
            [self.tableView reloadData];
        }
        [HDManager stopLoading];
        
    }];
    
}


#pragma mark - UICollectionView协议方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return  self.dataArray.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellID = @"MyCell";
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    
    BrandOneModel *model = _dataArray[indexPath.item];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    
    return cell;
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((SCREEN_WIDTH - (4 * gap)) / 3, (SCREEN_WIDTH - (4 * gap)) / 3);
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    //    NSLog(@"@1");
    BrandSelectViewController *bsVC = [[BrandSelectViewController alloc]init];//初始化
    BrandOneModel *model = self.dataArray[indexPath.item];
    
    
    bsVC.brandID = model.brandId;
    
    bsVC.brandNa = model.brandName;
    
    bsVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:bsVC animated:YES];
    
    
}

#pragma mark - UITableView协议方法


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.listarray.count;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    NSLog(@"11111");
    
    NSArray *array = self.listarray[section];
    
    return array.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qqq"];
    
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qqq"];
        
    }
    //    NSLog(@"%d",self.array.count);
    
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"%d",[self.array[indexPath.row]intValue]];
    NSArray *array = self.listarray[indexPath.section];
    BrandOneModel *model = array[indexPath.row];
    
    
    
    //    [buildNameStr stringByAppendingString:@"dsafsafsdfadsf"];
    //    buildNameStr = [buildNameStr stringByAppendingString:[NSString stringWithFormat:@"%@,",buildName]];
    
    
    //    string = [string stringByAppendingFormat:@"%@,%@",string1, string2];
    NSString *str1,*str2,*str3;
    
    str1 = model.brandName;
    str2 = model.brandNameSecond;
    
    if (str2 == NULL || str2 == nil || [str2 isEqualToString:@""]){
        cell.textLabel.text = str1;
    }else{
        str3 = [str1 stringByAppendingString:@"/"];
        str3 = [str3 stringByAppendingString:str2];
        
        cell.textLabel.text = str3;
    }
    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return @"A";
    }else if (section == 1){
        return @"B";
    }else if (section == 2){
        return @"C";
    }else if (section == 3){
        return @"D";
    }else if (section == 4){
        return @"E";
    }else if (section == 5){
        return @"F";
    }else if (section == 6){
        return @"G";
    }else if (section == 7){
        return @"H";
    }else if (section == 8){
        return @"I";
    }else if (section == 9){
        return @"J";
    }else if (section == 10){
        return @"K";
    }else if (section == 11){
        return @"L";
    }else if (section == 12){
        return @"M";
    }else if (section == 13){
        return @"N";
    }else if (section == 14){
        return @"O";
    }else if (section == 15){
        return @"P";
    }else if (section == 16){
        return @"Q";
    }else if (section == 17){
        return  @"R";
    }else if (section == 18){
        return @"S";
    }else if (section == 19){
        return  @"T";
    }else if (section == 20){
        return  @"U";
    }else if (section == 21){
        return  @"V";
    }else if (section == 22){
        return  @"W";
    }else if (section == 23){
        return  @"X";
    }else if (section == 24){
        return  @"Y";
    }else{
        return @"Z";
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    NSArray *array = self.listarray[section];
    
    if (array.count == 0){
        return 0;
    }
    return 40;
}
//取消cell的选中状态   cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    NSLog(@"@1");
    
    BrandSelectViewController *bsVC = [[BrandSelectViewController alloc]init];//初始化
    BrandOneModel *model = self.listarray[indexPath.section][indexPath.row];
    bsVC.brandID = model.brandId;
    bsVC.brandNa = model.brandName;
    
    
    bsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bsVC animated:YES];
    
}

#pragma mark -索引条

//设置右侧索引条
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray *array = @[@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    
    return array;
    
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (index == 0){
        tableView.contentOffset = CGPointZero;
    }
    return  index - 1;
    
    
}




@end
