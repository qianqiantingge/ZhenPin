//
//  PricIntervalModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "PricIntervalModel.h"

@implementation PricIntervalModel

//当模型的属性个数和字典中的key不匹配时，让赋值正常进程
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"Id": @"id"}];
}

@end
