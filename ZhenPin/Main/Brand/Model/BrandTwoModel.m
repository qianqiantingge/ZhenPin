//
//  BrandTwoModel.m
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "BrandTwoModel.h"

@implementation BrandTwoModel
//当模型的属性个数和字典中的key的个数不完全匹配时，让赋值能够正常进行
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end
