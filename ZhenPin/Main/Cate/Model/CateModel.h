//
//  CateModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CateModel : NSObject

@property (nonatomic, assign) NSNumber * categoryId;
@property (nonatomic, copy) NSString * categoryName;


+ (id)modelWith: (NSDictionary *)dic;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
