//
//  BrandOneModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface BrandOneModel : JSONModel


@property (nonatomic, assign) NSNumber *brandId;
@property (nonatomic,copy) NSString * brandName;
@property (nonatomic,copy) NSString * brandNameSecond;
@property (nonatomic, copy) NSString * logo;

@end
