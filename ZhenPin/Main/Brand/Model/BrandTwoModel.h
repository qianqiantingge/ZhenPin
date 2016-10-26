//
//  BrandTwoModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface BrandTwoModel : JSONModel


@property (nonatomic,copy) NSString *brandname;

@property (nonatomic,copy) NSNumber *channel;

@property (nonatomic,copy) NSString *imageSource;

@property (nonatomic, copy) NSString *isMJActivity;

@property (nonatomic,copy) NSNumber *marketPrice;

@property (nonatomic,copy) NSNumber *price;

@property (nonatomic,copy) NSNumber *productId;

@property (nonatomic,copy) NSString *productName;

@property (nonatomic,copy) NSNumber *stock;


@end
