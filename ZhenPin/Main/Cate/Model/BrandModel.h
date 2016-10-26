//
//  BrandModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface BrandModel : JSONModel

@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, strong) NSString * brandName;
@property (nonatomic, strong) NSString * brandNameSecond;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString * brandPinyin;
@property (nonatomic, strong) NSString * urlPath;

@end
