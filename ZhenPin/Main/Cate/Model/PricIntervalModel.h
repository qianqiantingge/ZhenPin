//
//  PricIntervalModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface PricIntervalModel : JSONModel

@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, assign) NSInteger priceStart;
@property (nonatomic, assign) NSInteger pirceEnd;

@end
