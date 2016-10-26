//
//  HeaderModel+netManger.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HeaderModel+netManger.h"
#import "Common.h"


@implementation HeaderModel (netManger)

+(void)requestCarrBage:(NSString *)str callBack:(void(^)(NSArray *array ,NSError *error))callBack{
    [BaseRequest postWithURL:CARURL  para:@{@"v":@"3.0",@"memberid":str} call:^(NSData *data, NSError *error) {
        if (error == nil) {
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dict3 = obj[@"result"][@"commonList"];
            NSMutableArray *array2 = [[NSMutableArray alloc]init];
        NSArray *arr = dict3[@"items"];
            for (NSDictionary *dic in arr){
                NSMutableArray *arr1 = dic[@"items"];
                for (NSDictionary *dict1 in arr1) {
                    HeaderModel *model = [[HeaderModel alloc]init];
                    model.specvalue = dict1[@"specvalue"];
                    model.price = dict1[@"price"];
                    model.colortext = dict1[@"colortext"];
                    model.imageSource = dict1[@"imageSource"];
                    model.brandname = dict1[@"brandname"];
                    model.productname = dict1[@"productname"];
                    model.productid = dict1[@"productid"];
                    [array2 addObject:model];
                    
                }
                
            
            }
     
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(array2,error);
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
            
       
            
        }
        
        
    }];
        

}
@end
