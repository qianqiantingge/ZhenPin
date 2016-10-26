//
//  BaseRequest.h
//  SSTES
//
//  Created by qianfeng on 16/9/26.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSObject

+(void)getWithUrl:(NSString *)url para:(NSDictionary *)para call:(void (^)(NSData* data,NSError* error))callBack;
+(void)postWithURL:(NSString *)url para:(NSDictionary *)para call:(void (^)(NSData* data,NSError* error))callBack;
@end
