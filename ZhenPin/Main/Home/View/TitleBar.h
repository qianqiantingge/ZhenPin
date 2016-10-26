//
//  TitleBar.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleBarProtocol <NSObject>

-(void)selectedWithIndex:(int)index;
@end


@interface TitleBar : UIView
+(instancetype)TitleBarWithFrame:(CGRect)frame vcArr:(NSArray*)vcArr dele:(id<TitleBarProtocol>)dele;
@end
