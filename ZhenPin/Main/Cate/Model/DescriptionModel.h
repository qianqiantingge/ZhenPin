//
//  DescriptionModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface DescriptionModel : JSONModel

@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * imageSource;
@property (nonatomic, copy) NSString * brandname;
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger marketPrice;

@property (nonatomic, assign) BOOL isLike;

@end
