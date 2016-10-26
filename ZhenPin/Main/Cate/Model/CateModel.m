//
//  CateModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "CateModel.h"

@implementation CateModel

+ (id)modelWith: (NSDictionary *)dic{
    CateModel * model = [[CateModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
