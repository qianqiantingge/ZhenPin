//
//  SearchViewController.h
//  ZhenPin
//
//  Created by qianfeng on 16/10/9.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchViewControllerProtocol <NSObject>
-(void)pushVC:(UIViewController*)vc withDisMissVC:(UIViewController*)vc2;
@end

@interface SearchViewController : UIViewController

@property(nonatomic,weak) id<SearchViewControllerProtocol> dele;
@end
