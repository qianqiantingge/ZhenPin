//
//  HomeModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/8.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HomeModel.h"
#import "BaseRequest.h"


@implementation ADModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}
@end



@implementation HeadModel
+(void)requestHeadData:(void (^)(NSArray* adArr,NSArray* cateArr,NSError* error))callBack{
    
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/homePage/getAppFirstPage.json?memberid=&v=2.0"];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr=(NSArray*)dict[@"result"][@"toplst"];
            NSArray *headAr=(NSArray*)dict[@"result"][@"showList"];
            
            NSMutableArray * adArr=[ADModel arrayOfModelsFromDictionaries:arr error:nil];
            NSMutableArray * headArr=[HeadModel arrayOfModelsFromDictionaries:headAr error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(adArr,headArr,nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,nil,error);
            });
        }
    }];
}
@end



@implementation TitleModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}

+(void)requestTitleData:(void (^)(NSArray* titleArr,NSError* error))callBack{
    
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/homePage/getChannelPageNavBar.json"];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr=(NSArray*)dict[@"result"][@"dataList"];

            
            NSMutableArray * titleArr=[TitleModel arrayOfModelsFromDictionaries:arr error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(titleArr,nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}
@end


@implementation MSModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self=[super init];
    if(self){
        
        _name=((NSDictionary*)dict[@"result"][@"quickBuyUrl"])[@"name"];
        _shareUrl=((NSDictionary*)dict[@"result"][@"quickBuyUrl"])[@"shareUrl"];

        
        NSArray *arr;
        NSArray *a=(NSArray*)dict[@"result"][@"groups"];
        for(int i=0;i<[a count];i++){
            if(((NSDictionary*)a[i])[@"products"]!=nil){
                arr=(NSArray*)((NSDictionary*)a[i])[@"products"];
                _groupId=((NSDictionary*)a[i])[@"groupId"];
                break;
            }
        }
        _brandArr=[BrandTModel arrayOfModelsFromDictionaries:arr error:nil];
    }
    return self;
}

+(void)requestData:(void (^)(NSArray* contentArr,NSError* error))callBack{
    
    NSString *url=[NSString stringWithFormat:@"http://tls.zhen.com/tls/quick/product/productList.json"];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray * contentArr=[MSModel arrayOfModelsFromDictionaries:@[dict] error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(contentArr,nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}
@end



@implementation BrandTModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}
@end


@implementation ContentModel
-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{

    if(self){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forKey:(NSString *)key{

    if([key isEqualToString:@"elementResult"]){
        _itemArr=[ItemModel arrayOfModelsFromDictionaries:value error:nil];
    }else if([key isEqualToString:@"jumpUrl"]||[key isEqualToString:@"imgUrl"]||[key isEqualToString:@"title"]||[key isEqualToString:@"tag"]){
        [super setValue:value forKey:key];
    }
}

+(void)requestDataWithPage:(int)page pageId:(NSString*)pageId call:(void (^)(NSArray* contentArr,NSError* error))callBack{
    
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/homePage/getAppADSpecialProduct.json?curPage=%d&pageId=%@",page,pageId];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray * contentArr=[ContentModel arrayOfModelsFromDictionaries:dict[@"result"][@"dataList"] error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(contentArr,nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}
@end

@implementation ItemModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}
@end
@implementation ItemTModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return true;
}
@end


@implementation HomeModel
+(void)requestDataWithPage:(int)page pageId:(NSString*)pageId call:(void (^)(ADModel *adM,NSArray *cateArr,NSArray* contentArr,NSArray *dataArr,NSError* error))callBack{
    NSString *url=[NSString stringWithFormat:@"http://home.zhen.com/home/channelPage/channelInfoList.json?curPage=%d&pageId=%@",page,pageId];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr=dict[@"result"][@"dataList"];
            
            if([[NSString stringWithFormat:@"%@",arr[0][@"groupId"]] isEqualToString:@"1"]){
                //
                ADModel *adMo=[[ADModel arrayOfModelsFromDictionaries:@[arr[0][@"elementResult"]] error:nil]lastObject];
                //
                NSMutableArray *caArr;
                NSArray *contentArr;
                if(arr[1][@"elementResult"][0][@"name"]==nil){
                    
                    NSArray *cArr=arr[2][@"elementResult"];
                    caArr=[[NSMutableArray alloc]init];
                    for(int i=0;i<cArr.count;i++){
                        [caArr addObject:cArr[i][@"name"]];
                    }
                    contentArr=[ItemTModel arrayOfModelsFromDictionaries:arr[1][@"elementResult"] error:nil];
                }else{
                    NSArray *cArr=arr[1][@"elementResult"];
                    caArr=[[NSMutableArray alloc]init];
                    for(int i=0;i<cArr.count;i++){
                        [caArr addObject:cArr[i][@"name"]];
                    }
                    contentArr=[ItemTModel arrayOfModelsFromDictionaries:arr[2][@"elementResult"] error:nil];
                }
                
                NSMutableArray *dataArr=[[NSMutableArray alloc]init];
                for(int i=3;i<arr.count;i++){
                    [dataArr addObject:arr[i]];
                }
                NSArray *daArr=[ContentModel arrayOfModelsFromDictionaries:dataArr error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(adMo,caArr,contentArr,daArr,nil);
                });
            }else{
            
                NSArray *daArr=[ContentModel arrayOfModelsFromDictionaries:arr error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(nil,nil,nil,daArr,nil);
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,nil,nil,nil,error);
            });
        }
    }];
}
@end


@implementation MSDetailModel

-(instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self=[super init];
    if(self){
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if([key isEqualToString:@"products"]){
        
        _brandArr=[BrandTModel arrayOfModelsFromDictionaries:value error:nil];
    }else if([key isEqualToString:@"endCountdown"] || [key isEqualToString:@"endTime"] || [key isEqualToString:@"groupId"] || [key isEqualToString:@"startTime"]){
        [super setValue:value forKey:key];
    }
}
+(void)requestDataWithGroupId:(NSString*)groupId call:(void (^)(NSArray *dataArr,NSError* error))callBack{
    NSString *url=[NSString stringWithFormat:@"http://tls.zhen.com/tls/quick/product/productList.json?groupId=%@&p=1",groupId];
    [BaseRequest getWithUrl:url para:nil call:^(NSData *data, NSError *error){
        if(error==nil){
            
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *arr=[MSDetailModel arrayOfModelsFromDictionaries:dict[@"result"][@"groups"] error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(arr,nil);
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                callBack(nil,error);
            });
        }
    }];
}
@end