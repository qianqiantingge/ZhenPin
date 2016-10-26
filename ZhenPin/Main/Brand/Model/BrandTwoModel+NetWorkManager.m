//
//  BrandTwoModel+NetWorkManager.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandTwoModel+NetWorkManager.h"

@implementation BrandTwoModel (NetWorkManager)
+(void)requestBrandTwoData:(NSInteger)page brandId:(NSNumber *)brandId callBack:(void (^)(NSArray *, NSNumber *, NSError *))callBack{
    
    
    
    NSDictionary *para = @{@"pagenumber":@(page),@"pagesize":@"20",@"noStock":@"1",@"brandid":brandId,@"v":@"2.0"};
    
    [BaseRequest postWithURL:@"http://search.zhen.com/search/search/productSearchForSift.json" para:para call:^(NSData *data, NSError *error) {
        
        //        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if (error==nil){
            
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            NSNumber *last = obj[@"result"][@"lastPageNumber"];
            
            NSArray *array = obj[@"result"][@"result"];
            
            NSMutableArray *brandArr = [BrandTwoModel arrayOfModelsFromDictionaries:array error:nil];
            
            
            //            NSLog(@"%@",brandArr);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                callBack(brandArr,last,nil);
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                callBack(nil,nil,error);
                
            });
            
        }
        
        
    }];
    
    
    
}

+(void)requestBrandTuijianData:(NSInteger)page brandId:(NSNumber *)brandId order:(NSInteger)order callBack:(void (^)(NSArray *, NSError *))callBack{
    
    NSDictionary *para = @{@"pagenumber":@(page),@"pagesize":@"20",@"noStock":@"1",@"order":@(order),@"brandid":brandId,@"v":@"2.0"};
    
    
    [BaseRequest postWithURL:@"http://search.zhen.com/search/search/productSearchForSift.json" para:para call:^(NSData *data, NSError *error) {
        
//        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if (error==nil){
            
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            NSArray *array = obj[@"result"][@"result"];
            
            NSMutableArray *brandArr = [BrandTwoModel arrayOfModelsFromDictionaries:array error:nil];
            
            
            //            NSLog(@"%@",brandArr);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                callBack(brandArr,nil);
                
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                callBack(nil,error);
                
            });
            
        }
        

        
    }];
    
    
    
    
}



@end
