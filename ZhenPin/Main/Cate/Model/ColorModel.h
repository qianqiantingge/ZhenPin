//
//  ColorModel.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/13.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import "JSONModel.h"

@interface ColorModel : JSONModel

@property (nonatomic, assign) NSInteger colorId;
@property (nonatomic, copy) NSString * colorName;
@property (nonatomic, copy) NSString * colorImg;
@property (nonatomic, copy) NSString * colorHEX;

@end
