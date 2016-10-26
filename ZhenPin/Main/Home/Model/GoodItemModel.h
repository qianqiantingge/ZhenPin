//
//  GoodItemModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface GoodItemModel : NSObject

@property(nonatomic,strong) NSArray *imgArr;
@property(nonatomic,copy) NSString *brandname;
@property(nonatomic,copy) NSString *productName;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *marketPrice;
@property(nonatomic,copy) NSString *activityName;
@property(nonatomic,copy) NSString *remind;
@property(nonatomic,copy) NSString *colorText;
@property(nonatomic,copy) NSString *msmall;
@property(nonatomic,strong) NSArray *sizeArr;
@property(nonatomic,strong) NSArray *detailArr;
@property(nonatomic,strong) NSArray *detailImgArr;
@property(nonatomic,copy) NSString *brandIntro;
@property(nonatomic,copy) NSString *brandImg;
@property(nonatomic,strong) NSArray *recomendArr;

@property(nonatomic,strong) NSArray *skuIdsArr;

+(void)requestRecomendDataWithProductId:(NSString*)productId call:(void (^)(GoodItemModel *goodItemM,NSError* error))callBack;
+(void)requestDetailDataWithProductId:(NSString*)productId call:(void (^)(GoodItemModel *goodItemM,NSError* error))callBack;
+(void)requestDataWithProductId:(NSString*)productId call:(void (^)(GoodItemModel *goodItemM,NSError* error))callBack;
@end


@interface GoodDetailModel : JSONModel
@property(nonatomic,copy) NSString *attrid;
@property(nonatomic,copy) NSString *attrname;
@property(nonatomic,copy) NSString *attrnameas;
@property(nonatomic,copy) NSString *attrvalues;
@property(nonatomic,copy) NSString *isshow;
@end


@interface RecomendGoodModel : JSONModel

@property(nonatomic,copy) NSString *msmall;
@property(nonatomic,copy) NSString *brandname;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *marketPrice;
@property(nonatomic,copy) NSString *goodsId;
@end