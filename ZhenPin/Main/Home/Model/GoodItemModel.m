//
//  GoodItemModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/10.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "GoodItemModel.h"
#import "BaseRequest.h"

@implementation GoodItemModel

+(void)requestDataWithProductId:(NSString*)productId call:(void (^)(GoodItemModel *goodItemM,NSError* error))callBack{
    
    //
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/products/ProductBaseInfo.json?noStock=1&productid=%@&v=2.1",productId];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *infoDic=[(NSArray*)dict[@"result"][@"ProductBaseInfo"] lastObject];
            
            GoodItemModel *goodIM=[[GoodItemModel alloc]init];
            goodIM.imgArr=dict[@"result"][@"ProductsImages"];
            goodIM.brandname=infoDic[@"brandname"];
            goodIM.productName=infoDic[@"productName"];
            goodIM.price=infoDic[@"price"];
            goodIM.marketPrice=infoDic[@"marketPrice"];
            goodIM.activityName=dict[@"result"][@"ProductsActivity"][@"activityName"];
            goodIM.remind=infoDic[@"remind"];
            goodIM.colorText=infoDic[@"colorText"];
            goodIM.msmall=infoDic[@"msmall"];
            
            NSMutableArray *sizeIdArr=[[NSMutableArray alloc]init];
            NSMutableArray *sizeTmpArr=[[NSMutableArray alloc]init];
            NSArray *ar=(NSArray*)dict[@"result"][@"ProductSize"];
            for(int i=0;i<ar.count;i++){
                if(ar[i][@"specvalue"]!=nil){
                    [sizeTmpArr addObject:ar[i][@"specvalue"]];
                    [sizeIdArr addObject:ar[i][@"productSpecId"]];
                }else{
                    [sizeTmpArr addObject:@"均码"];
                }
            }
            goodIM.skuIdsArr=sizeIdArr;
            goodIM.sizeArr=sizeTmpArr;
            goodIM.detailArr=[GoodDetailModel arrayOfModelsFromDictionaries:dict[@"result"][@"ProductsAttr"] error:nil];
            goodIM.detailImgArr=dict[@"result"][@"productImageDetails"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(goodIM,nil);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}

+(void)requestDetailDataWithProductId:(NSString*)productId call:(void (^)(GoodItemModel *goodItemM,NSError* error))callBack{
    
    //
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/products/getBrandInfo.json?noStock=1&productid=%@&v=2.1",productId];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *branDict=dict[@"result"][@"brandInfo"];
            
            GoodItemModel *goodIM=[[GoodItemModel alloc]init];
            goodIM.brandIntro=branDict[@"brandIntro"];
            
            goodIM.brandImg=[NSString stringWithFormat:@"http://pic2.zhenimg.com/brand/%@",[[branDict[@"brandImg"] componentsSeparatedByString:@"/"]lastObject]];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(goodIM,nil);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}

+(void)requestRecomendDataWithProductId:(NSString*)productId call:(void (^)(GoodItemModel *goodItemM,NSError* error))callBack{
    
    //
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/products/getRoundProductByBrand.json?productid=%@",productId];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            GoodItemModel *goodIM=[[GoodItemModel alloc]init];
            goodIM.recomendArr=[RecomendGoodModel arrayOfModelsFromDictionaries:dict[@"result"] error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(goodIM,nil);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}
@end



@implementation GoodDetailModel
@end



@implementation RecomendGoodModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}
@end