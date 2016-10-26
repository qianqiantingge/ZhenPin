//
//  UserModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
static UserModel *_user = nil;
+(instancetype)shareInatance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _user = [[self alloc] init];
    });
    return _user;
}
@end
