//
//  HomeModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ADModel : JSONModel
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,copy) NSString *jumpUrl;
@property(nonatomic,copy) NSString *title;
@end


@interface HeadModel : JSONModel
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *url;
@property(nonatomic,copy) NSString *share;
+(void)requestHeadData:(void (^)(NSArray* adArr,NSArray* cateArr,NSError* error))callBack;
@end



@interface TitleModel : JSONModel
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *name;
+(void)requestTitleData:(void (^)(NSArray* titleArr,NSError* error))callBack;
@end


@interface MSModel : JSONModel
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *shareUrl;
@property(nonatomic,strong) NSArray *brandArr;
@property(nonatomic,copy) NSString *groupId;
+(void)requestData:(void (^)(NSArray* contentArr,NSError* error))callBack;
@end

@interface BrandTModel : JSONModel
@property(nonatomic,copy) NSString *brandname;
@property(nonatomic,copy) NSString *msmall;
@property(nonatomic,copy) NSString *marketPrice;
@property(nonatomic,copy) NSString *premiumPrice;
@property(nonatomic,copy) NSString *productName;
@property(nonatomic,copy) NSString *stock;
@property(nonatomic,copy) NSString *productId;
@end

@interface MSDetailModel : JSONModel
@property(nonatomic,copy) NSString *endCountdown;
@property(nonatomic,copy) NSString *endTime;
@property(nonatomic,copy) NSString *groupId;
@property(nonatomic,copy) NSString *startTime;
@property(nonatomic,strong) NSArray *brandArr;

+(void)requestDataWithGroupId:(NSString*)groupId call:(void (^)(NSArray *dataArr,NSError* error))callBack;
@end


@interface ContentModel : JSONModel
@property(nonatomic,copy) NSString *jumpUrl;
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *tag;
@property(nonatomic,strong) NSArray *itemArr;
+(void)requestDataWithPage:(int)page pageId:(NSString*)pageId call:(void (^)(NSArray* contentArr,NSError* error))callBack;
@end

@interface ItemModel : JSONModel
@property(nonatomic,copy) NSString *activityPrice;
@property(nonatomic,copy) NSString *customname;
@property(nonatomic,copy) NSString *marketPrice;
@property(nonatomic,copy) NSString *productImage;
@property(nonatomic,copy) NSString *productId;
@property(nonatomic,copy) NSString *tag;
@end

@interface ItemTModel : ItemModel
@property(nonatomic,copy) NSString *brandName;
@end


@interface HomeModel : JSONModel
+(void)requestDataWithPage:(int)page pageId:(NSString*)pageId call:(void (^)(ADModel *adM,NSArray *cateArr,NSArray* contentArr,NSArray *dataArr,NSError* error))callBack;
@end