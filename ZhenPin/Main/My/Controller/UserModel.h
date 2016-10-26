//
//  UserModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *memberid;

+(instancetype) shareInatance;
@end
