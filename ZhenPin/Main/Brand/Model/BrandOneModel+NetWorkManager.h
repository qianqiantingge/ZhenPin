//
//  BrandOneModel+NetWorkManager.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandOneModel.h"
#import "BaseRequest.h"

@interface BrandOneModel (NetWorkManager)
//请求数据
+(void)requestCateData:(void(^)(NSArray *brand,NSError *error))callBack;


+(void)requestBrandData:(void(^)(NSMutableArray *list,NSError *error))callBack;


@end
