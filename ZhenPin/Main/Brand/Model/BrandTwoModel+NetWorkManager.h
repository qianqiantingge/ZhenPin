//
//  BrandTwoModel+NetWorkManager.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandTwoModel.h"
#import "BaseRequest.h"
@interface BrandTwoModel (NetWorkManager)
//请求数据

+(void)requestBrandTwoData:(NSInteger) page brandId:(NSNumber *) brandId callBack:(void(^)(NSArray *array,NSNumber *lastPage, NSError *error))callBack;




//请求推荐按钮的数据
+(void)requestBrandTuijianData:(NSInteger) page brandId:(NSNumber *)brandId order:(NSInteger)order callBack:(void(^)(NSArray *array,NSError *error))callBack;


@end
