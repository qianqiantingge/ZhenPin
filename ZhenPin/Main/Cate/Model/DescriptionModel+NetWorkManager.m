//
//  DescriptionModel+NetWorkManager.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/11.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "DescriptionModel+NetWorkManager.h"

#import "BaseRequest.h"

@implementation DescriptionModel (NetWorkManager)

+ (void)requestDescriptionData: (NSString *)baseID other: (NSString *)gender page: (NSInteger)page brandID: (NSString *)brandID order: (NSString *)order colorID: (NSString *)colorID priceStart: (NSString *)priceStart priceEnd: (NSString *)priceEnd searchtext: (NSString *)searchtext callBack: (void (^)(NSArray * , NSArray * , NSArray * , NSArray * brandArray, NSError *))callBack {
    
    NSString * str = @"http://home.zhen.com/home/products/productSearchForSift.json";
    
    NSDictionary * para1 = @{@"pagenumber": @(page), @"pagesize": @20, @"noStock": @1, @"cid": baseID, @"gender": gender, @"v": @2.0, @"brandid": brandID, @"order": order, @"colorid": colorID, @"pricestart": priceStart, @"priceend": priceEnd, @"searchtext": searchtext};
    
    [BaseRequest postWithURL:str para:para1 call:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //1,解析下边的collectionView的数据
            NSDictionary * dic = obj[@"result"];
            NSArray * resultArr = dic[@"page"][@"result"];
            NSMutableArray * resultArray = [DescriptionModel arrayOfModelsFromDictionaries:resultArr error:nil];
            
            //2,解析上边三个按钮的数据
            NSDictionary * dict = dic[@"parameter"];
            NSArray * colorArr = dict[@"colorTree"];
            NSMutableArray * colorArray = [ColorModel arrayOfModelsFromDictionaries:colorArr error:nil];
            NSArray * pricIntervalArr = dict[@"pricIntervalTree"];
            NSMutableArray * pricIntervalArray = [PricIntervalModel arrayOfModelsFromDictionaries:pricIntervalArr error:nil];
            NSArray * brandArr = dict[@"brandTree"];
            NSMutableArray * brandArray = [BrandModel arrayOfModelsFromDictionaries:brandArr error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(resultArray, colorArray, pricIntervalArray, brandArray, nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil, nil, nil, nil, error);
            });
        }
    }];
}

+ (void)requestLike:(NSString *)productId urlStr: (NSString *)urlStr callBack:(void (^)(NSArray *, NSError *))callBack {
    NSMutableDictionary * para = [[NSMutableDictionary alloc] init];
    [para setValue:@"ECD753C1-6451-48C5-B5B7-A66517C1B859" forKey:@"deviceid"];
    [para setValue:@0 forKey:@"isbuy"];
    [para setValue:productId forKey:@"productid"];
    [para setValue:@3.0 forKey:@"v"];
    [para setObject:@"D1FED7D3-FA6C-470F-A939-44A008B49595" forKey:@"idfv"];
    NSLog(@"%@", [UserModel shareInatance].token);
    NSLog(@"%@", [UserModel shareInatance].memberid);
    if ([UserModel shareInatance].memberid != nil) {
        NSLog(@"已经登录了");
        [para setValue:[UserModel shareInatance].token forKey:@"access_token"];
        [para setValue:[UserModel shareInatance].memberid forKey:@"memberid"];
    }

    [BaseRequest postWithURL:urlStr para:para call:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary * obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", obj);
//            NSDictionary * dict= obj[@"result"];
//            NSMutableArray * array = [[NSMutableArray alloc] init];
//            [array addObject:dict[@"isOK"]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                callBack(array, nil);
//            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil, error);
            });
        }
    }];
}

@end
