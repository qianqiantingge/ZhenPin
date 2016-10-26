//
//  HeaderModel+netManger.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "HeaderModel.h"
#import "BaseRequest.h"

@interface HeaderModel (netManger)
+(void)requestCarrBage:(NSString *)str callBack:(void(^)(NSArray *array ,NSError *error))callBack;
    
    
   
@end
