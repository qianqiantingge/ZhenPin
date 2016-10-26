//
//  BaseRequest.m
//  SSTES
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BaseRequest.h"
#import "UserModel.h"

@implementation BaseRequest



+(void)getWithUrl:(NSString *)url para:(NSDictionary *)para call:(void (^)(NSData* data,NSError* error))callBack{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlStr = [[NSMutableString alloc]initWithString:url];
    if (para != nil){
        [urlStr appendString:[self encodeUniCode:[self parasToString:para]]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"GET";
    [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Mobile/14A456 ZhenpinAPP/3.3 Paros/3.2.13" forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    UserModel *userM=[UserModel shareInatance];
    if(userM.memberid!=nil){
        [request addValue:[NSString stringWithFormat:@"zpmemberid=%@; zptoken=%@; zpusername=%@; deviceid=ECD753C1-6451-48C5-B5B7-A66517C1B859; zpiv=D1FED7D3-FA6C-470F-A939-44A008B49595",userM.memberid,userM.token,userM.username] forHTTPHeaderField:@"Cookie"];
    }
    [request addValue:@"keep-alive" forHTTPHeaderField:@"Proxy-Connection"];
//    [request addValue:@"54" forHTTPHeaderField:@"Content-Length"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil){
            callBack(data,nil);
        }else{
            callBack(nil,error);
        }
    }];
    //启动请求任务
    [dataTask resume];
}


+(void)postWithURL:(NSString *)url para:(NSDictionary *)para call:(void (^)(NSData* data,NSError* error))callBack{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableString *urlStr = [[NSMutableString alloc]initWithString:url];
    if (para != nil){
        [urlStr appendString:[self encodeUniCode:[self parasToString:para]]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    request.HTTPMethod = @"POST";
    [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
    [request addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Mobile/14A456 ZhenPin/3.3 ZhenpinAPP/3.3 Paros/3.2.13" forHTTPHeaderField:@"User-Agent"];
    [request addValue:@"keep-alive" forHTTPHeaderField:@"Proxy-Connection"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    UserModel *userM=[UserModel shareInatance];
    if(userM.memberid!=nil){
        [request addValue:[NSString stringWithFormat:@"zpmemberid=%@; zptoken=%@; zpusername=%@; deviceid=ECD753C1-6451-48C5-B5B7-A66517C1B859; zpiv=D1FED7D3-FA6C-470F-A939-44A008B49595",userM.memberid,userM.token,userM.username] forHTTPHeaderField:@"Cookie"];
    }
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil){
            callBack(data,nil);
        }else{
            callBack(nil,error);
        }
    }];
    //启动请求任务
    [dataTask resume];
}


+(NSString*)parasToString:(NSDictionary *)para{
    
    NSMutableString *paraStr = [[NSMutableString alloc]initWithString:@"?"];
    [para enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [paraStr appendFormat:@"%@=%@&",key,obj];
    }];
    if ([paraStr hasPrefix:@"&"]){
        [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length - 1, 1)];
    }
    
    return paraStr;
}

+(NSString*)encodeUniCode:(NSString*)string{
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}
@end
