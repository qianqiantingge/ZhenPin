//
//  HeaderModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/14.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface HeaderModel : JSONModel
@property (nonatomic,copy) NSString * imageSource;
@property (nonatomic,copy) NSString * productname;
@property (nonatomic,copy) NSString * specvalue;
@property (nonatomic,copy) NSString * colortext;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * brandname;
@property (nonatomic,copy) NSString * productid;

@end
