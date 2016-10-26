//
//  CateChildModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "CateChildModel.h"

@implementation CateChildModel

+ (id)modelWith:(NSDictionary *)dic {
    CateChildModel * model = [[CateChildModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
