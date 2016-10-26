//
//  SearchViewController.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "SearchViewController.h"
#import "Common.h"
#import "BaseRequest.h"
#import "HDManager.h"
#import "DetailsViewController.h"


@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{

    UIView *_searchView;
    UIView *_recomView;
    NSArray *_array;
    NSArray *_keyArr;
    NSArray *_remArr;
    UITableView *_contentTV;
    UITextField *searchBar;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    
    _remArr=[NSKeyedUnarchiver unarchiveObjectWithFile:RecomendSearch_PATH];
    //
    [self setHeadBar];
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)loadData{

    [HDManager startLoading];
    [BaseRequest getWithUrl:@"http://home.zhen.com/home/homePage/getHotSearchWords.json" para:nil call:^(NSData *data, NSError *error) {
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *dataArr=resultDic[@"result"][@"hotSearchWords"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _array=dataArr;
            [self createUI];
            [HDManager stopLoading];
        });
    }];
}
-(void)loadSearchDataWithContent:(NSString*)content{
    
    [BaseRequest getWithUrl:[NSString stringWithFormat:@"http://home.zhen.com/home/products/getSuggestWord.json"] para:@{@"num":@"15",@"searchWord":content} call:^(NSData *data, NSError *error) {
        if(error==nil){
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr=resultDic[@"result"][@"suggestWord"];
            NSMutableArray *tmpArr=[[NSMutableArray alloc]init];
            for(int i=0;i<arr.count;i++){
                [tmpArr addObject:arr[i][@"suggest"]];
            }
            _keyArr=tmpArr;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(_keyArr.count!=0){
                    _searchView.hidden=true;
                    _recomView.hidden=true;
                    _contentTV.hidden=false;
                    [_contentTV reloadData];
                }else{
                    _searchView.hidden=false;
                    _recomView.hidden=false;
                    _contentTV.hidden=true;
                }
            });
        }
    }];
}


-(void)setHeadBar{
    //
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:headView];
    
    searchBar=[[UITextField alloc]initWithFrame:CGRectMake(gap*1.6, 28, headView.frame.size.width-60-gap*1.6, 29)];
    [searchBar becomeFirstResponder];
    [searchBar setFont:[UIFont systemFontOfSize:13]];
    [searchBar setPlaceholder:@"iPhone7"];
    [searchBar setDelegate:self];
    [searchBar setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:1]];
    [searchBar.layer setCornerRadius:15.0];
    [searchBar.layer setMasksToBounds:true];
    [searchBar setLeftViewMode:UITextFieldViewModeAlways];
    UIView *leftV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, searchBar.frame.size.height)];
    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 16, searchBar.frame.size.height)];
    [imgV setImage:[UIImage imageNamed:@"search"]];
    [imgV setContentMode:UIViewContentModeScaleAspectFit];
    [leftV addSubview:imgV];
    [searchBar setLeftView:leftV];
    [headView addSubview:searchBar];
    //
    UIButton *cancleButton=[[UIButton alloc]initWithFrame:CGRectMake(headView.frame.size.width-gap-40, CGRectGetMidY(searchBar.frame)-20/2, 40, 20)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [cancleButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
    [cancleButton setTag:120];
    [cancleButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:cancleButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentChange) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)createUI{

    //
    [self setAutomaticallyAdjustsScrollViewInsets:false];
    [self.view setBackgroundColor:BGCOLOR];
    
    //
    _searchView=[[UIView alloc]initWithFrame:CGRectMake(gap, 64+gap, SCREEN_WIDTH-gap*2, 250)];
    [_searchView setBackgroundColor:[UIColor whiteColor]];
    [_searchView.layer setCornerRadius:6.0];
    [_searchView.layer setMasksToBounds:true];
    [self.view addSubview:_searchView];
    //
    UILabel *titlLabel=[[UILabel alloc]initWithFrame:CGRectMake(gap, 7, 120, 25)];
    [titlLabel setFont:[UIFont systemFontOfSize:13]];
    [titlLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [titlLabel setTextAlignment:NSTextAlignmentLeft];
    [titlLabel setText:@"热门搜索"];
    [_searchView addSubview:titlLabel];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titlLabel.frame)+7, _searchView.frame.size.width-10, 1.5)];
    [lineView setBackgroundColor:BGCOLOR];
    [_searchView addSubview:lineView];
    //
    CGFloat widthL=10;
    CGFloat numL=0;
    for(int i=0;i<_array.count;i++){
        UIButton *button=[[UIButton alloc]init];
        [button setBackgroundColor:[UIColor colorWithWhite:0.93 alpha:1]];
        [button setTitle:_array[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [button setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:true];
        [button.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:1].CGColor];
        [button.layer setBorderWidth:0.5];
        [button setTag:320+i];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:button];
        
        CGFloat width=[(NSString*)_array[i] boundingRectWithSize:CGSizeMake(300, 18) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.width+17;
        if(widthL+width>_searchView.frame.size.width-20){
            numL+=1;
            widthL=10;
        }
        [button.layer setCornerRadius:15];
        button.frame=CGRectMake(widthL, CGRectGetMaxY(lineView.frame)+10+numL*(30+10), width, 30);
        
        widthL+=width+gap;
    }
    _searchView.frame=CGRectMake(_searchView.frame.origin.x, _searchView.frame.origin.y, _searchView.frame.size.width, CGRectGetMaxY(lineView.frame)+10+(1+numL)*(30+10));
    
    //
    _recomView=[[UIView alloc]initWithFrame:CGRectMake(gap, CGRectGetMaxY(_searchView.frame)+10, SCREEN_WIDTH-gap*2, 40.5+40*_remArr.count)];
    if(_remArr.count>0){
        _recomView.hidden=false;
    }else{
        _recomView.hidden=true;
    }
        
    [_recomView setBackgroundColor:[UIColor whiteColor]];
    [_recomView.layer setCornerRadius:6.0];
    [_recomView.layer setMasksToBounds:true];
    [self.view addSubview:_recomView];
    //
    UILabel *titlRLabel=[[UILabel alloc]initWithFrame:CGRectMake(gap, 7, 120, 25)];
    [titlRLabel setFont:[UIFont systemFontOfSize:13]];
    [titlRLabel setTextColor:[UIColor colorWithWhite:0.2 alpha:1]];
    [titlRLabel setTextAlignment:NSTextAlignmentLeft];
    [titlRLabel setText:@"最近搜索"];
    [_recomView addSubview:titlRLabel];
    UIButton *deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(_recomView.frame.size.width-gap-15, 7, 15, 20)];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton setTag:200];
    [deleteButton addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [_recomView addSubview:deleteButton];
    UIView *lineRView=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titlRLabel.frame)+7, _recomView.frame.size.width-10, 1.5)];
    [lineRView setBackgroundColor:BGCOLOR];
    [_recomView addSubview:lineRView];
    //
    UITableView *recomTV=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineRView.frame), _recomView.frame.size.width, 40*_remArr.count) style:UITableViewStylePlain];
    [recomTV setTag:500];
    [recomTV setDelegate:self];
    [recomTV setDataSource:self];
    [recomTV setBackgroundColor:[UIColor whiteColor]];
    [recomTV setSeparatorInset:UIEdgeInsetsZero];
    [recomTV setScrollEnabled:false];
    [_recomView addSubview:recomTV];
    
    //
    _contentTV=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+10, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_contentTV setDelegate:self];
    [_contentTV setDataSource:self];
    [_contentTV setBackgroundColor:[UIColor clearColor]];
    [_contentTV setHidden:true];
    [_contentTV setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_contentTV];
}

// 点击按钮
-(void)handleButton:(UIButton*)button{
    
    if(button.tag==120){
        [self.view endEditing:true];
        [self dismissViewControllerAnimated:false completion:nil];
    }else if(button.tag==200){
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定清空历史内容？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [NSKeyedArchiver archiveRootObject:[NSArray array] toFile:RecomendSearch_PATH];
            _recomView.hidden=true;
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }else if(button.tag>=320){  // 热门搜索button
        
        DetailsViewController *detailC=[[DetailsViewController alloc]init];
        detailC.url=[NSString stringWithFormat:@"%@",button.currentTitle];
        
        [self.dele pushVC:detailC withDisMissVC:self];
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}



//
-(void)contentChange{
    [self loadSearchDataWithContent:searchBar.text];
}


// dele
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==500){
        return _remArr.count;
    }else{
        return _keyArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==500){
        return 40;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView.tag==500){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ccc"];
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccc"];
            UILabel *titlLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
            [titlLabel setFont:[UIFont systemFontOfSize:12]];
            [titlLabel setTag:101];
            [titlLabel setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
            [titlLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:titlLabel];
        }
        [(UILabel*)[cell.contentView viewWithTag:101] setText:_remArr[indexPath.row]];
        
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cc"];
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cc"];
            [cell setBackgroundColor:[UIColor clearColor]];
            UILabel *titlLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
            [titlLabel setFont:[UIFont systemFontOfSize:15]];
            [titlLabel setTag:100];
            [titlLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
            [titlLabel setTextAlignment:NSTextAlignmentLeft];
            [cell.contentView addSubview:titlLabel];
        }
        [(UILabel*)[cell.contentView viewWithTag:100] setText:_keyArr[indexPath.row]];
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if(tableView.tag!=500){
        NSMutableArray *tmpArr=[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:RecomendSearch_PATH]];
        [tmpArr addObject: _keyArr[indexPath.row]];
        [NSKeyedArchiver archiveRootObject:tmpArr toFile:RecomendSearch_PATH];
    // http://home.zhen.com/home/products/productSearchForSift.json?noStock=1&pagenumber=1&pagesize=20&searchtext=%E4%BA%9A%E5%8E%86%E5%B1%B1%E5%A4%A7%C2%B7%E9%BA%A6%E6%98%86&v=2.0
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}

@end
