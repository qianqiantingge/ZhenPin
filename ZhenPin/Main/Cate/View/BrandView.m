//
//  BrandView.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandView.h"

@implementation BrandView 

- (NSMutableArray *)brandArray {
    if (!_brandArray) {
        _brandArray = [[NSMutableArray alloc] init];
    }
    return _brandArray;
}

- (instancetype)initWithFrame:(CGRect)frame array: (NSArray *)array {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self.brandArray addObjectsFromArray:array];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.mj_w, self.mj_h - 80)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
        
        _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, _tableView.mj_y + _tableView.mj_h + 10, self.mj_w - 160, 40)];
        [self addSubview:_allBtn];
        _allBtn.backgroundColor = [UIColor redColor];
        _allBtn.layer.cornerRadius = 20;
        _allBtn.clipsToBounds = YES;
        [_allBtn setTitle:@"所有品牌" forState:UIControlStateNormal];
        [_allBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *array = self.brandArray[section];
//    return array.count;
    return  self.brandArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qqq"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qqq"];
    }
    
    BrandModel * model = self.brandArray[indexPath.row];
    if ([model.brandNameSecond  isEqual: @""]) {
        cell.textLabel.text = model.brandName;
    }else{
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@/%@", model.brandName, model.brandNameSecond ];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

//取消cell的选中状态   cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//委托方第三步：回调
    [self.delegate backIndex:indexPath.row];
}

//#pragma mark -索引条
////设置右侧索引条
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//
//    NSMutableArray * arr = [[NSMutableArray alloc] init];
//    for (int i = 0; i < self.brandArray.count; i++) {
//        BrandModel * model = self.brandArray[i];
//        unichar first = [model.brandName characterAtIndex:0];
//        [arr addObject:@(first)];
//        for (int x = 0; x < arr.count; x++) {
//            for (int y = 0; y < arr.count - x; y++) {
//                if (arr[y] > arr[y + 1]) {
//                    id tmp = arr[y];
//                    arr[y] = arr[y + 1];
//                    arr[y + 1] = tmp;
//                }
//            }
//        }
//    }
//    return arr;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    if (index == 0){
//        tableView.contentOffset = CGPointZero;
//    }
//    return  index - 1;
//}

@end
