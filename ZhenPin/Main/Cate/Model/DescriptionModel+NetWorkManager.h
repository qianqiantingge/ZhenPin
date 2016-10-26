//
//  DescriptionModel+NetWorkManager.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "DescriptionModel.h"

#import "ColorModel.h"
#import "PricIntervalModel.h"
#import "BrandModel.h"
#import "UserModel.h"

//二级页面的网络请求
@interface DescriptionModel (NetWorkManager)

+ (void)requestDescriptionData: (NSString *)baseID  other: (NSString *)gender page: (NSInteger)page brandID: (NSString *)brandID order: (NSString *)order colorID: (NSString *)colorID priceStart: (NSString *)priceStart priceEnd: (NSString *)priceEnd searchtext: (NSString *)searchtext callBack: (void(^)(NSArray * array, NSArray * colorArray, NSArray * pricIntervalArray, NSArray * brandArray, NSError * error))callBack;

+ (void)requestLike:(NSString *)productId urlStr: (NSString *)urlStr callBack:(void (^)(NSArray *, NSError *))callBack;
@end
