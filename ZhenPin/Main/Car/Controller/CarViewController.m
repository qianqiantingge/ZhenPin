//
//  CarViewController.m
//  SSTGoods
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//
//http://shop.zhen.com/shopapi/cart/dropItem.json
//v=3.0&productspecid=10092706&memberid=941325

#import "CarViewController.h"
#import "CarTableViewCell.h"
#import "HeaderModel.h"
#import "HeaderModel+netManger.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
@interface CarViewController  ()<UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray *dataSourse;
// 下标集合
@property NSMutableArray *selectIndexPathsArray;
//@property NSInteger tag1;
@property   NSInteger count;
@property   NSInteger count1;
@property UIButton *button;
@property NSMutableArray * result;
@property NSInteger sum;
@end

@implementation CarViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _viewHidden = [[UIView alloc]init];
    _viewHidden.frame = self.view.bounds;
    [self.view addSubview:_viewHidden];
    _viewTab = [[UIView alloc]init];
    _viewTab.frame = self.view.bounds;
    [self.view addSubview:_viewTab];
    _viewTab.hidden  = YES;
    //实例化数组
    self.selectIndexPathsArray = [[NSMutableArray alloc]init];
    self.result = [[NSMutableArray alloc]init];
    _dataSourse = [[NSMutableArray alloc]init];
    [self createTableView];
    [self CreateView];
    [self EditBtnLab];
    [self FishBtn];
    [self loadData];
    
    
    
}
#pragma mark 网络请求
-(void)viewWillAppear:(BOOL)animated{
    [self loadData];


}

-(void)loadData{
    NSString *str = @"941325";
//    UserModel *use = [UserModel shareInatance];
//    NSString *str = use.memberid;
    if (str == nil){
        [self.viewHidden setHidden:NO];
        [self.viewTab  setHidden:YES];
        self.navigationController.navigationBarHidden = YES;
        return;
    }else{
    [HeaderModel requestCarrBage:str callBack:^(NSArray *array, NSError *error) {
        if (array.count == 0){
            [self.viewHidden setHidden:NO];
            [self.viewTab  setHidden:YES];
            self.navigationController.navigationBarHidden = YES;
            
        }else {
            [self.viewHidden setHidden:YES];
            [self.viewTab setHidden:NO];
            [_dataSourse addObjectsFromArray:array];
            
            [_tableView reloadData];
            
            
        }
       
        
    }];
    }
    
}

-(void)CreateView{
    UIImageView *img = [[UIImageView alloc]init];
    img.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    img.center =  CGPointMake(self.viewHidden.center.x, 3*self.viewHidden.center.y/5);
    
    img.image = [UIImage imageNamed:@"bag.jpg"];
    [self.viewHidden addSubview:img];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(img.frame.origin.x, img.frame.origin.y +img.frame.size.height + 10, SCREEN_WIDTH/3, SCREEN_WIDTH/6);
    label.text = @"快来挑选几个喜欢的商品哦哦";
    label.font = [UIFont systemFontOfSize:12];
    label.numberOfLines = 0;
    [self.viewHidden addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(label.frame.origin.x, label.frame.size.height+label.frame.origin.y + 50, SCREEN_WIDTH/3, SCREEN_WIDTH/12);
    [button setTitle:@"去逛逛" forState:UIControlStateNormal];
      button.layer.cornerRadius = 15;
    button.backgroundColor = [UIColor redColor];
    [self.viewHidden addSubview:button];
    [button addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)backTo{
        self.tabBarController.selectedIndex = 0;
    
    
}
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    //设置编辑模式下可以多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"CarTableViewCell" bundle:nil] forCellReuseIdentifier:@"222"];
    [self createRightBarButtonItem];
    [self.viewTab addSubview:self.tableView];
    
}
#pragma mark - 协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourse.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"222"forIndexPath:indexPath];
    HeaderModel *model = _dataSourse[indexPath.row];
    NSString *strDe = [NSString stringWithFormat:@"%@%@",model.brandname,model.productname];
    NSString *sizeDe = [NSString stringWithFormat:@"%@%@",model.specvalue,model.colortext];
    cell.detailL.text = strDe;
    cell.sizeL.text = sizeDe;
    
    cell.priceL.text = [NSString stringWithFormat:@"￥%@",model.price];
    cell.imageV.backgroundColor = [UIColor redColor];
    NSURL *url = [NSURL URLWithString:model.imageSource];
    [cell.imageV sd_setImageWithURL:url];
    
    
    return cell;
}

-(void)resultArray1:(NSIndexPath *)indexPath{
    
    
    CarTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSArray *arrS =  [cell.priceL.text componentsSeparatedByString:@"￥"];
    NSString *str = [arrS objectAtIndex:1];
    NSInteger price = [str integerValue];
    NSInteger result1 = price * cell.count;
    NSString *string = [NSString stringWithFormat:@"%ld",(long)result1];
    [self.result addObject:string];
    
    
    
}

///选中的时候将下标添加到数组中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectIndexPathsArray addObject:indexPath];
    
    
}


//取消选中的时候将该下标删除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",self.selectIndexPathsArray.count);
    
    [self.selectIndexPathsArray removeObject:indexPath];
    NSLog(@"%ld",self.selectIndexPathsArray.count);
    

    
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete
    | UITableViewCellEditingStyleInsert;
    
}

- (void)itemHandle:(UIBarButtonItem *)item
{
    BOOL state = self.tableView.isEditing;
    [self.tableView setEditing:!state animated:YES];
    item.title = state ? @"编辑" : @"完成";
    UIButton *button = [self.view viewWithTag:4];
    UIButton *button2 = [self.view viewWithTag:2];
    UIButton *button3 = [self.view viewWithTag:3];
    UIButton *button1 = [self.view viewWithTag:1];
    UILabel *label = [self.view viewWithTag:55];
    if (self.tableView.isEditing) {
        [self.result removeAllObjects];
        
        [self.selectIndexPathsArray removeAllObjects];
        [_dataSourse removeObjectsInArray:_selectIndexPathsArray];
        //         在编辑状态
        _sum = 0;
        button.hidden = YES;
        button2.hidden = NO;
        button3.hidden = NO;
        button3.enabled = YES;
        self.selectAllBtn.hidden = NO;
        
        [button1 addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [button2 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }else {
            _sum = 0;
        label.hidden = YES;
        button2.hidden = YES;
        button3.hidden = YES;
        button.hidden = NO;
        self.selectAllBtn.hidden = YES;
        if (self.selectIndexPathsArray.count == 0){
            NSString *str = [NSString stringWithFormat:@"合计￥%d  去清算（%d)",0,0];
            [button setTitle:str forState:UIControlStateNormal];
            
        }else {
            // >>>>>>>>>>>>>>>>>>>>>>    将得到的数据和全部加到此处
            
            for (int i = 0; i < self.selectIndexPathsArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [self resultArray:indexPath];
                
                
                
            }
            NSInteger number = 0;
            for (int i = 0; i<self.result.count; i++) {
                NSString *co = self.result[i];
                number = [co integerValue];
                _sum += number;
                
            }
            NSString *str = [NSString stringWithFormat:@"合计￥%ld 去清算（%ld)种商品",_sum,_selectIndexPathsArray.count];
            [button setTitle:str forState:UIControlStateNormal];
        }
        
    }
    
    
}
#pragma mark 创建UI
- (void)createRightBarButtonItem

{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(itemHandle:)];
    self.navigationItem.rightBarButtonItem = item;
    
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    _selectAllBtn.frame = CGRectMake(0, 0, 60, 30);
    
    [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_selectAllBtn];
    
    self.navigationItem.rightBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItems = @[item,leftItem];
    
    
}
- (void)selectAllBtnClick:(UIButton *)button {
    UIButton *btn = [self.view viewWithTag:3];
    btn.enabled = NO;
    
    for (int i = 0; i < self.dataSourse.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self resultArray:indexPath];
    }
    [self.selectIndexPathsArray addObjectsFromArray:self.dataSourse];
    
}


-(void)resultArray:(NSIndexPath *)indexPath{
    CarTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSArray *arrS =  [cell.priceL.text componentsSeparatedByString:@"￥"];
    NSString *str = [arrS objectAtIndex:1];
    NSInteger price = [str integerValue];
    NSInteger result1 = price * cell.count;
    NSString *string = [NSString stringWithFormat:@"%ld",(long)result1];
    [self.result addObject:string];
    
}

// 移入收藏
-(void)BtnClick:(UIButton *)button{
    UILabel *label = [self.view viewWithTag:55];
    //判断数据源是否为空
    if ((self.dataSourse.count == 0)  || (self.selectIndexPathsArray.count == 0) ){
        label.hidden = NO;
    }else if (self.selectIndexPathsArray.count != 0){
        label.hidden = YES;
        
    }
    
    
}
// 删除按钮
-(void)ClickToDele:(UIButton *)btn {
 
    
    [self deleteRowsAtIndexPaths1:_selectIndexPathsArray];
    [self.tableView reloadData];
    [_selectIndexPathsArray removeAllObjects];
 
}

#pragma mark 删除方法
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSourse removeObjectAtIndex:indexPath.row];
}

- (void)deleteRowsAtIndexPaths1:(NSMutableArray *)indexPathsArray
{
    //因为顺序删除前面会影响后面的下标，所以删除的时候有bug，所以我们应该倒序删除，倒序删除后面的不影响前面的下标，所以是正确的
    //首先排序,将数组中indexPath排序
    NSArray *array = [indexPathsArray sortedArrayUsingSelector:@selector(compare:)];
    //倒序删除
    for (int i = (int)array.count - 1; i >= 0; i--) {
        NSIndexPath *indexPath = array[i];
        [self deleteRowAtIndexPath:indexPath];
    }
    
}
-(void)FishBtn{
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT-100,  (SCREEN_WIDTH/3-gap)*2, 48);
    button4.layer.cornerRadius = 24;
    button4.tag = 4;
    button4.hidden = YES;
    button4.backgroundColor = [UIColor redColor];
    button4.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.viewTab addSubview:button4];
    
}

-(void)EditBtnLab{
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"请先输入数量" forState:UIControlStateNormal];
    button1.frame = CGRectMake(gap, SCREEN_HEIGHT-100, SCREEN_WIDTH/3-2*gap, 48);
    button1.tag = 1;
    button1.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.viewTab addSubview:button1];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"移入收藏" forState:UIControlStateNormal];
    button2.frame = CGRectMake(SCREEN_WIDTH/3, SCREEN_HEIGHT-100, SCREEN_WIDTH/3-gap, 48);
    button2.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button2 setImage:[UIImage imageNamed:@"redHeart.png"] forState:UIControlStateNormal];
    button2.layer.cornerRadius = 24;
    button2.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.viewTab addSubview:button2];
    button2.tag = 2;
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"删除" forState:UIControlStateNormal];
    button3.frame = CGRectMake(2*SCREEN_WIDTH/3, SCREEN_HEIGHT-100, SCREEN_WIDTH/3-gap, 48);
    button3.backgroundColor = [UIColor redColor];
    button3.layer.cornerRadius = 24;
    [button3 setImage:[UIImage imageNamed:@"dele.png"] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button3.titleLabel.font = [UIFont systemFontOfSize:10];
    [button3 setImage:[[UIImage imageNamed:@"dele_highlight.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateSelected];
    button3.tag = 3;
    
    [self.viewTab addSubview:button3];
    [button3 addTarget:self action:@selector(ClickToDele:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3+gap,SCREEN_HEIGHT-120, SCREEN_WIDTH/3-gap, 50)];
    label.backgroundColor = [UIColor blackColor];
    label.text = @"您还没有选择商品";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.hidden = YES;
    label.tag = 55;
    [self.viewTab addSubview:label];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-102, SCREEN_WIDTH, 1)];
    view1.backgroundColor = [UIColor blackColor];
    [self.viewTab addSubview:view1];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 1)];
    view2.backgroundColor = [UIColor blackColor];
    [self.viewTab addSubview:view2];
    
    
}

@end
