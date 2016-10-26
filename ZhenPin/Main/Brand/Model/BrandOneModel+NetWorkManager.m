//
//  BrandOneModel+NetWorkManager.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandOneModel+NetWorkManager.h"

@implementation BrandOneModel (NetWorkManager)
+(void)requestCateData:(void (^)(NSArray *, NSError *))callBack{
    
    [BaseRequest postWithURL:@"http://home.zhen.com/home/brandPage/initPage.json" para:@{@"v":@2.0,@"source":@3} call:^(NSData *data, NSError *error) {
        
        
        
        if(error == nil){
            
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSArray *brand = obj[@"result"][@"HotBrand"];
            
            
            NSMutableArray *brandArray = [[NSMutableArray alloc]init];
            
            brandArray = [BrandOneModel arrayOfModelsFromDictionaries:brand error:nil];
            
            //             NSLog(@"brand = %@",brandArray);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(brandArray,nil);
                
            });
            
            
            
        }else{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
            
            
            
        }
        
        
    }];
    
    
}


+(void)requestBrandData:(void (^)(NSMutableArray *, NSError *))callBack{
    
    [BaseRequest postWithURL:@"http://home.zhen.com/home/brandPage/goodsBrandByName.json?v=2.0&charactergroup=A%2CB%2CC%2CD%2CE%2CF%2CG%2CH%2CI%2CJ%2CK%2CL%2CM%2CN%2CO%2CP%2CQ%2CR%2CS%2CT%2CU%2CV%2CW%2CX%2CY%2CZ" para:nil call:^(NSData *data, NSError *error) {
        
        
        if (error == nil){
            
            //            NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            
            NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            
            NSDictionary *dict = obj[@"result"];
            
            NSArray *arrayA = dict[@"A"];
            NSArray *arrayB = dict[@"B"];
            NSArray *arrayC = dict[@"C"];
            NSArray *arrayD = dict[@"D"];
            NSArray *arrayE = dict[@"E"];
            NSArray *arrayF = dict[@"F"];
            NSArray *arrayG = dict[@"G"];
            NSArray *arrayH = dict[@"H"];
            NSArray *arrayI = dict[@"I"];
            NSArray *arrayJ = dict[@"J"];
            NSArray *arrayK = dict[@"K"];
            NSArray *arrayL = dict[@"L"];
            NSArray *arrayM = dict[@"M"];
            NSArray *arrayN = dict[@"N"];
            NSArray *arrayO = dict[@"O"];
            NSArray *arrayP = dict[@"P"];
            NSArray *arrayQ = dict[@"Q"];
            NSArray *arrayR = dict[@"R"];
            NSArray *arrayS = dict[@"S"];
            NSArray *arrayT = dict[@"T"];
            NSArray *arrayU = dict[@"U"];
            NSArray *arrayV = dict[@"V"];
            NSArray *arrayW = dict[@"W"];
            NSArray *arrayX = dict[@"X"];
            NSArray *arrayY = dict[@"Y"];
            NSArray *arrayZ = dict[@"Z"];
            
            
            NSMutableArray *listA = [BrandOneModel arrayOfModelsFromDictionaries:arrayA error:nil];
            NSMutableArray *listB = [BrandOneModel arrayOfModelsFromDictionaries:arrayB error:nil];
            NSMutableArray *listC = [BrandOneModel arrayOfModelsFromDictionaries:arrayC error:nil];
            NSMutableArray *listD = [BrandOneModel arrayOfModelsFromDictionaries:arrayD error:nil];
            NSMutableArray *listE = [BrandOneModel arrayOfModelsFromDictionaries:arrayE error:nil];
            NSMutableArray *listF = [BrandOneModel arrayOfModelsFromDictionaries:arrayF error:nil];
            NSMutableArray *listG = [BrandOneModel arrayOfModelsFromDictionaries:arrayG error:nil];
            NSMutableArray *listH = [BrandOneModel arrayOfModelsFromDictionaries:arrayH error:nil];
            NSMutableArray *listI = [BrandOneModel arrayOfModelsFromDictionaries:arrayI error:nil];
            NSMutableArray *listJ = [BrandOneModel arrayOfModelsFromDictionaries:arrayJ error:nil];
            NSMutableArray *listK = [BrandOneModel arrayOfModelsFromDictionaries:arrayK error:nil];
            NSMutableArray *listL = [BrandOneModel arrayOfModelsFromDictionaries:arrayL error:nil];
            NSMutableArray *listM = [BrandOneModel arrayOfModelsFromDictionaries:arrayM error:nil];
            NSMutableArray *listN = [BrandOneModel arrayOfModelsFromDictionaries:arrayN error:nil];
            NSMutableArray *listO = [BrandOneModel arrayOfModelsFromDictionaries:arrayO error:nil];
            NSMutableArray *listP = [BrandOneModel arrayOfModelsFromDictionaries:arrayP error:nil];
            NSMutableArray *listQ = [BrandOneModel arrayOfModelsFromDictionaries:arrayQ error:nil];
            NSMutableArray *listR = [BrandOneModel arrayOfModelsFromDictionaries:arrayR error:nil];
            NSMutableArray *listS = [BrandOneModel arrayOfModelsFromDictionaries:arrayS error:nil];
            NSMutableArray *listT = [BrandOneModel arrayOfModelsFromDictionaries:arrayT error:nil];
            NSMutableArray *listU = [BrandOneModel arrayOfModelsFromDictionaries:arrayU error:nil];
            NSMutableArray *listV = [BrandOneModel arrayOfModelsFromDictionaries:arrayV error:nil];
            NSMutableArray *listW = [BrandOneModel arrayOfModelsFromDictionaries:arrayW error:nil];
            NSMutableArray *listX = [BrandOneModel arrayOfModelsFromDictionaries:arrayX error:nil];
            NSMutableArray *listY = [BrandOneModel arrayOfModelsFromDictionaries:arrayY error:nil];
            NSMutableArray *listZ = [BrandOneModel arrayOfModelsFromDictionaries:arrayZ error:nil];
            
            
            NSMutableArray *list = [[NSMutableArray alloc]init];
            
            
            [list addObject:listA];
            [list addObject:listB];
            [list addObject:listC];
            [list addObject:listD];
            [list addObject:listE];
            [list addObject:listF];
            [list addObject:listG];
            [list addObject:listH];
            [list addObject:listI];
            [list addObject:listJ];
            [list addObject:listK];
            [list addObject:listL];
            [list addObject:listM];
            [list addObject:listN];
            [list addObject:listO];
            [list addObject:listP];
            [list addObject:listQ];
            [list addObject:listR];
            [list addObject:listS];
            [list addObject:listT];
            [list addObject:listU];
            [list addObject:listV];
            [list addObject:listW];
            [list addObject:listX];
            [list addObject:listY];
            [list addObject:listZ];
            
            //            NSLog(@"%d",list.count);
            
            
            //            NSMutableArray *listArr = [[NSMutableArray alloc]initWithObjects:arrayA,arrayB,arrayC,arrayD,arrayE,arrayF,arrayG,arrayH,arrayI,arrayJ,arrayK,arrayL,arrayM,arrayN,arrayO,arrayP,arrayQ,arrayR,arrayS,arrayT,arrayU,arrayV,arrayW,arrayX,arrayY,arrayZ, nil];
            //
            //            NSLog(@"%d",listArr.count);
            //
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(list,nil);
                
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
        
        
    }];
    
    
    
    
    
    
    
}




@end
