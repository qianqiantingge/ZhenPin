//
//  MyTabBarView.swift
//  DMDMD
//
//  Created by qianfeng on 16/9/1.
//  Copyright © 2016年 chenxiang. All rights reserved.
//

/*
 使用：
    self.automaticallyAdjustsScrollViewInsets=false
 
    let myTabBarV=MyTabBarView.init(frame: CGRectMake(0, 22, SCREEN_WIDTH, SCREEN_HEIGHT-22), vcArr: vcArr)
    self.view.addSubview(myTabBarV)
 
 
 当前button处于左右边界时滚动topSV
 
 button总长度小于屏幕宽时，平分屏幕。          滚动bodySV时，line跟随滚动。
 button总长度大于屏幕宽时，按内容设button宽。  滚动bodySV时，line不跟随滚动。
 */

import UIKit

@objc protocol MyTabBarDelegate:NSObjectProtocol {
    // 选中某页调用
    optional func selectedWithIndex(index:Int)
}

class MyTabBarView: UIView {
    
    weak var myDelegate:MyTabBarDelegate?       // delegate
    
    let lineBigButtonLeft:CGFloat=3               // line 左边超出button(在button总长度>屏幕宽时有效，<时规定了固定大小)
    let lineH:CGFloat=2.3                         // line 高
    let tabHeight:CGFloat=40                      // tabBar 高
    let tabButtonFontSize:CGFloat=14              // tabBar button字体大小
    let tabMargin:CGFloat=20                      // tabBar 左右边距
    let tabBgColor:UIColor=UIColor.init(white: 0.95, alpha: 1)                     // tabBar bgColor
    let tabButtonTitleColorNormal:UIColor=UIColor.init(white: 0.45, alpha: 1)      // tabBar button标题颜色(normal)
    let tabButtonTitleColorSelected:UIColor=UIColor.blackColor()     // tabBar button标题颜色(selected)
    let lineColor:UIColor=UIColor.init(red: 0, green: 120.0/255, blue: 255.0/255, alpha: 1) // line color
    
    var tabRedDotArr:NSMutableArray=NSMutableArray()    // 红点Arr(用于隐藏、显示)
    var tabButtonArr:NSMutableArray=NSMutableArray()    // buttonArr
    var currentTabSelected:Int=0                        // 当前 选中
    var isUseDragging:Bool=false                        // 是否 是手指触摸滚动（用于立刻更新、滚动结束再更新）
    var isLess=false                                    // 是否 所有button长度少于屏幕宽（用于规定button大小、滚动topSV）
    
    var time:NSTimeInterval=1.2                         // 当前button处于边界时topSV滚动时间
    var currentTopLeft:CGFloat=0        // 用于判断是否处于边界
    var currentTopRight:CGFloat=0       // 用于判断是否处于边界
    
    var vcArr:NSArray!                  // [子控制器]
    var tabView:UIScrollView!           // topSV
    lazy var bodySV:UIScrollView={      // bodySV
        
        let bodyScrollView=UIScrollView.init(frame: CGRectMake(0, self.tabHeight, self.frame.size.width, self.frame.size.height-self.tabHeight))
        bodyScrollView.delegate=self
        bodyScrollView.pagingEnabled=true
        bodyScrollView.bounces=true
        bodyScrollView.showsHorizontalScrollIndicator=true
        bodyScrollView.autoresizingMask=[.FlexibleHeight, .FlexibleBottomMargin,.FlexibleWidth]
        self.addSubview(bodyScrollView)
        
        return bodyScrollView
    }()
    lazy var updateButton:((x:Int)->())={    // 更新选中button的颜色，并记录当前下标
        let bu=self.tabButtonArr[self.currentTabSelected] as! UIButton
        bu.selected=false
        let buC=self.tabButtonArr[$0] as! UIButton
        buC.selected=true
        self.currentTabSelected=$0
        UIView.animateWithDuration(0.3, animations: {
            bu.transform=CGAffineTransformIdentity
            buC.transform=CGAffineTransformMakeScale(1.05, 1.05)
        })
    }
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init(frame: CGRect,vcArr:NSArray,dele:MyTabBarDelegate) {
        self.init(frame:frame)
        
        self.vcArr=vcArr
        self.myDelegate=dele
        createUI()
    }
    
    
    // UI
    func createUI(){
        
        // topSV
        self.tabView=UIScrollView.init(frame: CGRectMake(0, 0, self.frame.width, self.tabHeight))
        self.tabView.showsHorizontalScrollIndicator=false
        self.tabView.backgroundColor=self.tabBgColor
        self.addSubview(tabView)
        //
        
        var widthL:CGFloat=self.tabMargin    // 记录每个button距屏幕的左边距
        for i in 0..<vcArr.count{
            // itemButton       （topSV）
            let itemButton=UIButton.init()
            let itemButtonWidth=(vcArr[i].title! as NSString).boundingRectWithSize(CGSizeMake(1000, frame.size.height-self.lineH), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(self.tabButtonFontSize)], context: nil).width+5
            itemButton.frame=CGRectMake(widthL, 0, itemButtonWidth, self.tabHeight)
            itemButton.tag=300+i
            itemButton.titleLabel?.baselineAdjustment = .AlignCenters       // ?
            itemButton.titleLabel?.font=UIFont.systemFontOfSize(self.tabButtonFontSize)
            itemButton.setTitle(vcArr[i].title, forState: .Normal)
            itemButton.setTitleColor(self.tabButtonTitleColorNormal, forState: .Normal)
            itemButton.setTitleColor(self.tabButtonTitleColorSelected, forState: .Selected)
            itemButton.addTarget(self, action: #selector(self.handleTabButton(_:)), forControlEvents: .TouchUpInside)
            self.tabView.addSubview(itemButton)
            self.tabButtonArr.addObject(itemButton)
            
            // 小红点             （topSV）
            let aRedDotView=UIView.init(frame:CGRectMake(itemButton.frame.size.width/2+3, itemButton.frame.size.height/2, 8, 8))
            aRedDotView.backgroundColor=UIColor.redColor()
            aRedDotView.layer.cornerRadius=aRedDotView.frame.width/2
            aRedDotView.layer.masksToBounds=true
            aRedDotView.hidden=true
            itemButton.addSubview(aRedDotView)
            self.tabRedDotArr.addObject(aRedDotView)
            
            // line             （topSV）
            if i==0{
                let lineView=UIView.init(frame: CGRectMake(itemButton.frame.origin.x-lineBigButtonLeft, itemButton.frame.height-lineH, itemButtonWidth+lineBigButtonLeft*2, lineH))
                lineView.tag=100
                lineView.backgroundColor=self.lineColor
                self.tabView.addSubview(lineView)
                
                // 默认选中button ， 当前选中下标
                itemButton.selected=true
                self.currentTabSelected=0
                itemButton.transform=CGAffineTransformMakeScale(1.05, 1.05)
            }
            // 更新左边距
            widthL+=(itemButtonWidth+self.tabMargin)
            
            
            //                  （bodySV）
            self.bodySV.addSubview(vcArr[i].view)
        }
        
        //                      （topSV）
        if widthL<self.frame.width{         // 不用滚动，总长度少于屏幕宽，重新更新button的宽
        
            self.isLess=true
            for i in 0..<self.tabButtonArr.count{
                let button=self.tabButtonArr[i] as! UIButton
                
                button.frame.size.width=self.frame.width/CGFloat(self.tabButtonArr.count)
                button.frame.origin.x=button.frame.width*CGFloat(i)
            }
            
            let lineView=self.tabView.viewWithTag(100)!
            lineView.frame.origin.x=(self.tabButtonArr[0] as! UIButton).frame.origin.x
            lineView.frame.size.width=(self.tabButtonArr[0] as! UIButton).frame.width
        }else{
        
            self.tabView.contentSize=CGSizeMake(widthL, self.tabView.frame.height)
        }
        
        //                      （bodySV）
        self.bodySV.contentSize=CGSizeMake(self.frame.width*CGFloat(vcArr.count), self.tabHeight)
        for i in 0..<vcArr.count{
            (vcArr[i].view as UIView).frame=CGRectMake(self.bodySV.frame.width*CGFloat(i), 0, self.bodySV.frame.width, self.bodySV.frame.height)
            if i==0{    // 立即刷新第一页（使用了VC的view，会走viewDidLoad，此时tableView的mj_head才有值）
                self.myDelegate?.selectedWithIndex?(0)
            }
        }
    }
 
    // 点击 标题button
    func handleTabButton(button:UIButton){
        isUseDragging=false
        self.selectTabWithIndex(button.tag-300, isAnimate: true)
    }
    
    // 改变 项
    func selectTabWithIndex(index:Int,isAnimate:Bool){
        
        if !isUseDragging{  // 点击时立刻更新button
            updateButton(x: index)
        }
    
        // 当前button
        let button=self.tabButtonArr[index] as! UIButton
        // 更新line的位置
        weak var weakSelf=self
        UIView.animateWithDuration(0.35, animations: {
            
            // line位置
            let lineView=self.viewWithTag(100)!
            var frame=lineView.frame
            if weakSelf!.isLess{    // 
                frame.origin.x=button.frame.origin.x
                frame.size.width=button.frame.width
            }else{
                frame.origin.x=button.frame.origin.x-weakSelf!.lineBigButtonLeft
                frame.size.width=button.frame.width+weakSelf!.lineBigButtonLeft*2
            }
            lineView.frame=frame
        }){ (finished) in
            if weakSelf!.isUseDragging && !weakSelf!.isLess{
                weakSelf!.updateButton(x:index)
            }
        }

        // 是点击                      （要滑动bodySV）
        if !isUseDragging{
            // 滚动bodySV
            UIView.animateWithDuration(1.5, animations: { 
                self.bodySV.setContentOffset(CGPointMake(CGFloat(index)*self.frame.width, 0), animated: isAnimate)
            })
        }
        
        // button总长度大于屏幕宽       （要在button处于边界的时候，滚动topSV）
        if !isLess{
            
            let maxX=self.tabView.contentSize.width            // contentSize宽度
            let button=self.tabButtonArr[index] as! UIButton   // 当前button
            if button.frame.maxX>(self.frame.width+currentTopLeft){     // 右边界在屏幕外（往右）
            
                if maxX-button.frame.minX<self.frame.width{ // 不够 完整左移
                    UIView.animateWithDuration(self.time, animations: {
                        self.tabView.contentOffset=CGPointMake(maxX-self.frame.width, 0)    // 偏移量
                    })
                    // 更新left
                    currentTopLeft=maxX-self.frame.width    // 就是偏移量
                    currentTopRight=maxX                    // 就是偏移量+屏幕宽
                }else{                                      // 够
                    UIView.animateWithDuration(self.time, animations: {
                        self.tabView.contentOffset=CGPointMake(button.frame.minX, 0)
                    })
                    // 更新left
                    currentTopLeft=button.frame.origin.x
                    currentTopRight=currentTopLeft+self.frame.width
                }
            }
            if button.frame.minX<(currentTopRight-self.frame.width){      // 左边界在屏幕外（往左）
                
                if button.frame.maxX-0<self.frame.width {    // 不够
                    UIView.animateWithDuration(self.time, animations: {
                        self.tabView.contentOffset=CGPointMake(0, 0)
                    })
                    currentTopLeft=0
                    currentTopRight=currentTopLeft+self.frame.width
                }else{      //
                    UIView.animateWithDuration(self.time, animations: {
                        self.tabView.contentOffset=CGPointMake(button.frame.maxX-self.frame.width, 0)
                    })
                    currentTopLeft=button.frame.maxX-self.frame.width
                    currentTopRight=currentTopLeft+self.frame.width
                }
            }
        }

        // 隐藏小红点（查阅了，所以隐藏）
        self.hideTabRedDot(index)
        
        // 调用delegate的 选中某项并滚动完毕后调用
        self.myDelegate?.selectedWithIndex?(index)
    }

    
    // 显示小红点
    func showTabRedDot(index:Int){
        (self.tabRedDotArr[index] as! UIView).hidden=false
    }
    // 隐藏小红点
    func hideTabRedDot(index:Int){
        (self.tabRedDotArr[index] as! UIView).hidden=true
    }
}


extension MyTabBarView:UIScrollViewDelegate{

    // 滚动完毕后调用，设置偏移量不调用（只有手拖动后）
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView==self.bodySV{     // 防止滚动topSV时也调用
            self.isUseDragging=true
            self.selectTabWithIndex(Int(scrollView.contentOffset.x/self.bounds.size.width), isAnimate: true)
        }
    }
    
    // 滚动时调用（连续触发）
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView==self.bodySV && isUseDragging{        // 是滑动
            if scrollView.contentOffset.x>0 && scrollView.contentOffset.x<CGFloat(self.tabButtonArr.count-1)*self.frame.width{    // 最左边< _ <最右边
                if self.isLess{     // 只在 button总长度小于屏幕宽时
                    // line位置
                    let lineView=self.viewWithTag(100)!
                    var frame=lineView.frame
                    frame.origin.x=scrollView.contentOffset.x/CGFloat(self.tabButtonArr.count)
                    lineView.frame=frame
                    
                    // 更新button标题
                    let x=lineView.frame.midX<self.frame.width/CGFloat(self.tabButtonArr.count) ? 0 : (lineView.frame.midX<self.frame.width/CGFloat(self.tabButtonArr.count)*2 ? 1: 2)
                    updateButton(x:x)
                }
            }
        }
    }
}