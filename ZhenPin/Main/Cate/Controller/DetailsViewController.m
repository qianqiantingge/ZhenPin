//
//  DetailsViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "DetailsViewController.h"

//代理方第一步：遵守协议
@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BrandViewDelegate, SearchViewControllerProtocol>

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView * backView;  //推荐弹出的显示小按钮的view
@property (nonatomic, strong) UIView * buttomView;  //推荐弹出下边灰色的view
@property (nonatomic, assign) UIButton * selectedBtn;  //推荐界面选中的按钮
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, strong) UIView * ssssView;  //筛选页面
@property (nonatomic, strong) UIButton * selectedButton;  //价位和颜色选中的按钮
@property (nonatomic, strong) UIScrollView * priceView;  //显示价位小按钮的view
@property (nonatomic, strong) UIScrollView * colorView;  //显示颜色小按钮的view
@property (nonatomic, strong) UIButton * priceSelectedBtn;  //价位中小按钮选中的
@property (nonatomic, strong) UIButton * colorSelectedBtn;  //颜色重小按钮被选中
@property (nonatomic, strong) NSMutableArray * colorArr;  //显示颜色的数据
@property (nonatomic, strong) NSMutableArray * pricIntervalArr;  //显示价位的数据
@property (nonatomic, strong) BrandView * brandView;  //品牌的view
@property (nonatomic, strong) NSMutableArray * brandArray;
@property (nonatomic, assign) NSInteger brandID;  //记录品牌页面选中的cell的id
@property (nonatomic, assign) NSInteger typeNumber;  //记录下拉刷新时是哪种网络请求


@end

@implementation DetailsViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 94) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"DescriptionCell" bundle:nil] forCellWithReuseIdentifier:@"DescriptionCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        //下拉刷新
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            if (self.typeNumber == 1) {
                [self loadData:@"" colorID:@"" priceStart:@"" priceEnd:@"" brandID:@"" searchtext:@""];
            }else if (self.typeNumber == 2) {
                [self tuijianRequest];
            }else if (self.typeNumber == 3 ) {
                [self pinpaiRequest];
            }else if (self.typeNumber == 4) {
                [self shaixuanRequest];
            }else if (self.typeNumber == 5) {
                [self loadData:@"" colorID:@"" priceStart:@"" priceEnd:@"" brandID:@"" searchtext:self.url];
            }
            
        }];
        //上拉加载更多
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            if (self.typeNumber == 1) {
                [self loadData:@"" colorID:@"" priceStart:@"" priceEnd:@"" brandID:@"" searchtext:@""];
            }else if (self.typeNumber == 2) {
                [self tuijianRequest];
            }else if (self.typeNumber == 3 ) {
                [self pinpaiRequest];
            }else if (self.typeNumber == 4) {
                [self shaixuanRequest];
            }else if (self.typeNumber == 5) {
                [self loadData:@"" colorID:@"" priceStart:@"" priceEnd:@"" brandID:@"" searchtext:self.url];
            }
        }];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

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

- (NSMutableArray *)brandArray {
    if (!_brandArray) {
        _brandArray = [[NSMutableArray alloc] init];
    }
    return _brandArray;
}

- (UIView *)brandView {
    if (!_brandView) {
        _brandView = [[BrandView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114) array:self.brandArray];
        _brandView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_brandView];
    }
    [_brandView.allBtn addTarget:self action:@selector(allBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _brandView.hidden = YES;
    return _brandView;
}

- (void)allBtnClick{
    self.brandView.hidden = YES;
}

- (NSMutableArray *)colorArr {
    if (!_colorArr) {
        _colorArr = [[NSMutableArray alloc] init];
    }
    return _colorArr;
}

- (NSMutableArray *)pricIntervalArr {
    if (!_pricIntervalArr) {
        _pricIntervalArr = [[NSMutableArray alloc] init];
    }
    return _pricIntervalArr;
}

- (UIScrollView *)priceView {
    if (!_priceView) {
        _priceView = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 50, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 114 - 50 - 60)];
        _priceView.contentSize = CGSizeMake(0, (self.pricIntervalArr.count + 1) * 40 + 10);
        _priceView.showsVerticalScrollIndicator = NO;
    }
    return _priceView;
}

- (UIScrollView *)colorView {
    if (!_colorView) {
        _colorView = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 50, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 114 - 50 - 60)];
        _colorView.contentSize = CGSizeMake(0, (self.colorArr.count + 1) * 40 + 10);
        _colorView.showsVerticalScrollIndicator = NO;
    }
    return _colorView;
}

//筛选页面
- (UIView *)ssssView {
    if (!_ssssView) {
        _ssssView = [[SelectedView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114)];
        [self.view addSubview:_ssssView];
        [self.view bringSubviewToFront:_ssssView];
        _ssssView.backgroundColor = [UIColor whiteColor];
        
        UIView * smallView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        smallView.backgroundColor = [UIColor whiteColor];
        [_ssssView addSubview:smallView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 80, 20)];
        label.text = @"只显示有货";
        label.font = [UIFont systemFontOfSize:13];
        [_ssssView addSubview:label];
        UISwitch * switchView = [[UISwitch alloc] initWithFrame:CGRectMake(180, 10, 40, 20)];
        [_ssssView addSubview:switchView];
        UIButton * priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 80, 50)];
        priceBtn.tag = 1111;
        [priceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [priceBtn setTitle:@"价位" forState:UIControlStateNormal];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_ssssView addSubview:priceBtn];
        [priceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedButton = priceBtn;
        
        UIButton * colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 90, 80, 40)];
        colorBtn.tag = 2222;
        [colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [colorBtn setTitle:@"颜色" forState:UIControlStateNormal];
        colorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        colorBtn.backgroundColor = BGCOLOR;
        [_ssssView addSubview:colorBtn];
        [colorBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ssssView addSubview:self.priceView];
        
        NSMutableArray * array2 = [[NSMutableArray alloc] init];
        [array2 addObject:@"全部"];
        for (int i = 0; i < self.pricIntervalArr.count; i++) {
            PricIntervalModel * model2 = self.pricIntervalArr[i];
            [array2 addObject:model2.text];
        }
        for (int i = 0; i < array2.count; i++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20 + (10 + 30) * i, self.priceView.mj_w - 40, 30)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:array2[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.priceView addSubview:btn];
            btn.tag = 1000 + i;
            [btn addTarget:self action:@selector(priceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.priceSelectedBtn = btn;
            }
        }
        [_ssssView addSubview:self.colorView];
        
        NSMutableArray * array1 = [[NSMutableArray alloc] init];
        [array1 addObject:@"全部"];
        for (int i = 0; i < self.colorArr.count; i++) {
            ColorModel * model1 = self.colorArr[i];
            [array1 addObject:model1.colorName];
        }
        for (int i = 0; i < array1.count; i++) {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20 + (10 + 30) * i, self.colorView.mj_w - 40, 30)];
            [self.colorView addSubview:btn];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitle:array1[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.tag = 10000 + i;
            [btn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.colorSelectedBtn = btn;
            }
        }
        self.colorView.hidden = YES;
        
        UIButton * chongzhiBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, self.priceView.mj_y + self.priceView.mj_h + 10, (SCREEN_WIDTH - 60) / 2, 40)];
        [chongzhiBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_ssssView addSubview:chongzhiBtn];
        chongzhiBtn.backgroundColor = [UIColor redColor];
        chongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        chongzhiBtn.layer.cornerRadius = 20;
        chongzhiBtn.clipsToBounds = YES;
        chongzhiBtn.tag = 11111;
        [chongzhiBtn addTarget:self action:@selector(chongzhiAndQuerenClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * querenBtn = [[UIButton alloc] initWithFrame:CGRectMake(40 + chongzhiBtn.mj_w, self.priceView.mj_y + self.priceView.mj_h + 10, chongzhiBtn.mj_w, 40)];
        [querenBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_ssssView addSubview:querenBtn];
        querenBtn.backgroundColor = [UIColor redColor];
        querenBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        querenBtn.layer.cornerRadius = 20;
        querenBtn.clipsToBounds = YES;
        querenBtn.tag = 22222;
        [querenBtn addTarget:self action:@selector(chongzhiAndQuerenClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _ssssView;
}

#pragma mark: - 重置和确认按钮的点击事件
- (void)chongzhiAndQuerenClick: (UIButton *)sender {
    if (sender.tag == 11111) {  //点击重置按钮
        UIButton * priceBtn = [self.priceView viewWithTag:1000];
        UIButton * colorBtn = [self.colorView viewWithTag:10000];
        if (self.priceSelectedBtn == priceBtn && self.colorSelectedBtn == colorBtn) {
            return;
        }
        [priceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.priceSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.priceSelectedBtn = priceBtn;
        [colorBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.colorSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.colorSelectedBtn = colorBtn;
    }else{  //点击确认按钮
        if (self.priceSelectedBtn.tag == 1000 || self.colorSelectedBtn.tag == 10000) {
            self.ssssView.hidden = YES;
            return;
        }
        [self shaixuanRequest];
        self.ssssView.hidden = YES;
    }
}

#pragma mark: - 筛选页面的确认按钮的网络请求
- (void)shaixuanRequest{
    NSInteger i = self.priceSelectedBtn.tag - 1000 - 1;
    NSInteger j = self.colorSelectedBtn.tag - 10000 - 1;
    PricIntervalModel * model1 = self.pricIntervalArr[i];
    ColorModel * model2 = self.colorArr[j];
    if (self.url == nil) {
        if (self.brandID == 0) {
            if (self.selectedNumber == 0) {
                [self loadData:@"" colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:@"" searchtext:@""];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:@"" searchtext:@""];
        }else{
            if (self.selectedNumber == 0) {
                [self loadData:@"" colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
        }
    }else{
        if (self.brandID == 0) {
            if (self.selectedNumber == 0) {
                [self loadData:@"" colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:@"" searchtext: self.url];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:@"" searchtext: self.url];
        }else{
            if (self.selectedNumber == 0) {
                [self loadData:@"" colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext: self.url];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd]  brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext: self.url];
        }
    }
    
}


//价位中各价位按钮的点击事件
- (void)priceBtnClick: (UIButton *)sender {
    if (sender == self.priceSelectedBtn) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.priceSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.priceSelectedBtn = sender;
}

//颜色中各按钮的点击事件
- (void)colorBtnClick: (UIButton *)sender {
    if (sender == self.colorSelectedBtn) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.colorSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.colorSelectedBtn = sender;
}

//价位，颜色按钮的点击事件
- (void)buttonClick: (UIButton *)sender{
    if (sender == self.selectedButton) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor whiteColor];
    [self.selectedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedButton.backgroundColor = BGCOLOR;
    self.selectedButton = sender;
    if (self.selectedButton.tag == 1111) {
        self.colorView.hidden = YES;
        self.priceView.hidden = NO;
    }else{
        self.priceView.hidden = YES;
        self.colorView.hidden = NO;
    }
}

#pragma mark: - 推荐页面按钮的点击事件
- (void)recommendBtnClick: (UIButton *)sender {
    if (sender == self.selectedBtn) {
        return;
    }
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectedBtn = sender;
    
    UIButton * tuijianBtn = [self.view viewWithTag:100];
    self.selectedNumber = 0;
    if (sender.tag == 10) {
        [tuijianBtn setTitle:@"推荐" forState:UIControlStateNormal];
    }else if (sender.tag == 11) {
        [tuijianBtn setTitle:@"人气" forState:UIControlStateNormal];
        self.selectedNumber = 6;
    }else if (sender.tag == 12){
        [tuijianBtn setTitle:@"最新" forState:UIControlStateNormal];
        self.selectedNumber = 4;
    }else if (sender.tag == 13){
        [tuijianBtn setTitle:@"价格↑" forState:UIControlStateNormal];
        self.selectedNumber = 3;
    }else if (sender.tag == 14){
        [tuijianBtn setTitle:@"价格↓" forState:UIControlStateNormal];
        self.selectedNumber = 2;
    }
    self.backView.hidden = YES;
    self.buttomView.hidden = YES;
    [self tuijianRequest];
}

#pragma mark: 推荐页面的网络请求
- (void)tuijianRequest {
    if (self.url == nil) {
        if (self.priceSelectedBtn.tag == 1000 ) {
            if (self.brandID == 0) {
                [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:@"" priceStart:@"" priceEnd:@"" brandID:@"" searchtext:@""];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:@"" priceStart:@"" priceEnd: @"" brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
        }else{
            NSInteger i = self.priceSelectedBtn.tag - 1000 - 1;
            NSInteger j = self.colorSelectedBtn.tag - 10000 - 1;
            PricIntervalModel * model1 = self.pricIntervalArr[i];
            ColorModel * model2 = self.colorArr[j];
            if (self.brandID == 0) {
                [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd: [NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: @"" searchtext:@""];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd: [NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
        }
        
    }else{
        if (self.priceSelectedBtn.tag == 1000 ) {
            if (self.brandID == 0) {
                [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:@"" priceStart:@"" priceEnd: @"" brandID: @"" searchtext:self.url];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:@"" priceStart:@"" priceEnd: @"" brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:self.url];
        }else{
            NSInteger i = self.priceSelectedBtn.tag - 1000 - 1;
            NSInteger j = self.colorSelectedBtn.tag - 10000 - 1;
            PricIntervalModel * model1 = self.pricIntervalArr[i];
            ColorModel * model2 = self.colorArr[j];
            if (self.brandID == 0) {
                [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd: [NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: @"" searchtext:self.url];
            }
            [self loadData:[NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd: [NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:self.url];
        }
        
    }
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

#pragma mark: SearchViewControllerProtocol 协议方法
- (void)pushVC:(UIViewController *)vc withDisMissVC:(UIViewController *)vc2 {
    [vc2 dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _titleName;
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.page = 1;
    self.typeNumber = 0;
    self.selectedNumber = 0;
    [self createBtn];
    if (self.url == nil) {
        [self loadData:@"" colorID:@"" priceStart:@"" priceEnd:@"" brandID: @"" searchtext:@""];
        self.typeNumber = 1;
    }else{
        [self loadData:@"" colorID:@"" priceStart:@"" priceEnd:@"" brandID:@"" searchtext:self.url];
        self.typeNumber = 5;
    }
}

- (void)paixuArray {
    for (int i = 1; i < self.brandArray.count; i++) {
        for (int j = 0; j < self.brandArray.count - i; j++) {
            BrandModel * model = self.brandArray[j];
            unichar first = [model.brandName characterAtIndex:0];
            BrandModel * model1 = self.brandArray[j+1];
            unichar first1 = [model1.brandName characterAtIndex:0];
            if (first > first1) {
                BrandModel * tmpModel = self.brandArray[j];
                self.brandArray[j] = self.brandArray[j+1];
                self.brandArray[j+1] = tmpModel;
            }
        }
    }
}

#pragma mark: - BrandViewDelegate 协议方法
//代理方第二步：实现方法
- (void)backIndex:(NSInteger)index {
    BrandModel * model = self.brandArray[index];
    self.brandID = model.brandId;
    [self pinpaiRequest];
    self.brandView.hidden = YES;
}

#pragma mark: - 品牌推荐页面的网络请求
- (void)pinpaiRequest{
    if (self.url == nil) {
        if (self.priceSelectedBtn.tag == 1000 && self.colorSelectedBtn.tag == 10000) {
            if (self.selectedNumber == 0) {
                [self loadData: @"" colorID: @"" priceStart: @"" priceEnd:@"" brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
            }
            [self loadData: [NSString stringWithFormat:@"%ld", self.selectedNumber] colorID: @"" priceStart: @"" priceEnd:@"" brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
        }else{
            NSInteger i = self.priceSelectedBtn.tag - 1000  ;
            NSInteger j = self.colorSelectedBtn.tag - 10000 ;
            PricIntervalModel * model1 = self.pricIntervalArr[i];
            ColorModel * model2 = self.colorArr[j];
            if (self.selectedNumber == 0) {
                [self loadData:@"" colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
            }
            [self loadData: [NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:@""];
        }
    }else{
        if (self.priceSelectedBtn.tag == 1000 && self.colorSelectedBtn.tag == 10000) {
            if (self.selectedNumber == 0) {
                [self loadData: @"" colorID: @"" priceStart: @"" priceEnd:@"" brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext:self.url];
            }
            [self loadData: [NSString stringWithFormat:@"%ld", self.selectedNumber] colorID: @"" priceStart: @"" priceEnd:@"" brandID:[NSString stringWithFormat:@"%ld", self.brandID] searchtext:self.url];
        }else{
            NSInteger i = self.priceSelectedBtn.tag - 1000  ;
            NSInteger j = self.colorSelectedBtn.tag - 10000 ;
            PricIntervalModel * model1 = self.pricIntervalArr[i];
            ColorModel * model2 = self.colorArr[j];
            if (self.selectedNumber == 0) {
                [self loadData:@"" colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:self.url];
            }
            [self loadData: [NSString stringWithFormat:@"%ld", self.selectedNumber] colorID:[NSString stringWithFormat:@"%ld", model2.colorId] priceStart:[NSString stringWithFormat:@"%ld", model1.priceStart] priceEnd:[NSString stringWithFormat:@"%ld", model1.pirceEnd] brandID: [NSString stringWithFormat:@"%ld", self.brandID] searchtext:self.url];
        }
    }
    
}

#pragma mark: - 数据请求
- (void)loadData: (NSString *)number colorID: (NSString *)colorId priceStart: (NSString *)priceStart priceEnd: (NSString *)priceEnd brandID: (NSString *)brandID searchtext: (NSString *)searchtext{
    [HDManager startLoading];
    if (self.baseID == nil) {
        self.baseID = @"";
        self.gender = @"";
    }
    [DescriptionModel requestDescriptionData:self.baseID other:self.gender page:self.page brandID:brandID order:number colorID:colorId priceStart:priceStart priceEnd:priceEnd searchtext:searchtext callBack:^(NSArray *array, NSArray *colorArray, NSArray *pricIntervalArray, NSArray *brandArray, NSError *error) {
        if (!error) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.collectionView reloadData];
            [self.colorArr addObjectsFromArray:colorArray];
            [self.pricIntervalArr addObjectsFromArray:pricIntervalArray];
            [self.brandArray addObjectsFromArray:brandArray];
            [self paixuArray];
            [self.brandView.tableView reloadData];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }else{
            UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"网络错误" message:@"请检查网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:action];
            [self presentViewController:ac animated:YES completion:nil];
        }
        [HDManager stopLoading];
    }];
}

//搜索按钮的点击事件
- (void)searchItemClick {
    SearchViewController * svc = [[SearchViewController alloc] init];
    svc.dele = self;
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)createBtn {
    NSArray * array = @[@"推荐", @"品牌", @"筛选"];
    CGFloat btnW = SCREEN_WIDTH / 3;
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
            self.typeNumber = 2;
            if (!sender.selected) {
                self.backView.hidden = YES;
                self.buttomView.hidden = YES;
                
            }else{
                self.backView.hidden = NO;
                self.buttomView.hidden = NO;
            }
            self.ssssView.hidden = YES;
            self.brandView.hidden = YES;
            break;
        }
        case 101:{
            self.typeNumber = 3;
            //代理方第三步：成为代理
            self.brandView.delegate = self;
            if (!sender.selected) {
                self.brandView.hidden = YES;
            }else{
                self.brandView.hidden = NO;
            }
            self.backView.hidden = YES;
            self.buttomView.hidden = YES;
            self.ssssView.hidden = YES;
        }
            break;
        default:
            self.typeNumber = 4;
            if (!sender.selected) {
                self.ssssView.hidden = YES;
            }else{
                self.ssssView.hidden = NO;
            }
            self.backView.hidden = YES;
            self.buttomView.hidden = YES;
            self.brandView.hidden = YES;
            break;
    }
}

#pragma mark: UICollectionView 协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"DescriptionCell";
    DescriptionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    DescriptionModel * model = _dataArray[indexPath.item];
    [cell.backImage sd_setImageWithURL:[NSURL URLWithString:model.imageSource]];
    NSMutableString * str = [[NSMutableString alloc] init];
    [str appendFormat:@"%@/%@", model.brandname, model.productName];
    cell.titleL.text = str;
    cell.nowPrice.text = [NSString stringWithFormat:@"￥%ld", model.price];
    cell.oldPrice.text = [NSString stringWithFormat:@"￥%ld", model.marketPrice];
    cell.likeBtn.tag = indexPath.item + 10;
//    [cell.likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (model.isLike) {
        [cell.likeBtn setImage:[UIImage imageNamed:@"红心"] forState:UIControlStateNormal];
    }else{
        [cell.likeBtn setImage:[UIImage imageNamed:@"心"] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark: - 收藏按钮点击事件
- (void)likeBtnClick: (UIButton *)sender {
//    可以完成点击
    DescriptionModel * model = self.dataArray[sender.tag - 10];
    model.isLike = !model.isLike;
    [self.collectionView reloadData];
    
//    [DescriptionModel requestLike: model.productId urlStr:@"http://uc.zhen.com/uc/myzhenpin/addToCollection.json" callBack:^(NSArray *likeArray, NSError *error) {
//        
//    }];
//    DescriptionModel * model = self.dataArray[sender.tag - 10];
//    if (model.isLike) {
//        [DescriptionModel requestLike:model.productId urlStr:@"http://uc.zhen.com/uc/myzhenpin/addToCollection.json" callBack:^(NSArray *likeArray, NSError *error) {
////            if ([likeArray[sender.tag - 10]  isEqual: @"true"]) {
////                model.isLike = !model.isLike;
////                [self.collectionView reloadData];
////            }
//        }];
//    }else{
//        [DescriptionModel requestLike:model.productId urlStr:@"http://uc.zhen.com/uc/myzhenpin/delCollectionById.json" callBack:^(NSArray *likeArray, NSError *error) {
//            if ([likeArray[sender.tag - 10]  isEqual: @"true"]) {
//                model.isLike = !model.isLike;
//                [self.collectionView reloadData];
//            }
//        }];
//    }
    
//    if ([UserModel shareInatance].memberid == nil) {
//        LoginViewController * lvc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:lvc animated:YES];
//    }else{
//        
//    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 18) / 2, (SCREEN_WIDTH - 18) / 2 + 80);
}

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodItemViewController * gvc = [[GoodItemViewController alloc] init];
    DescriptionModel * model = self.dataArray[indexPath.item];
    gvc.productId = model.productId;
    [self.navigationController pushViewController:gvc animated:YES];
}

@end
