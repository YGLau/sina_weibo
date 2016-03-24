//
//  PopoverAnimator.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/24/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    // 定义一个变量保存当前是否展开
    var isPresented:Bool = false
    
    // 定义属性保存菜单的大小
    var presentFrame = CGRectZero
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        return pc
    }
    /**
     一旦实现这个方法,系统转场动画就没有了,转场动画就由自己来实现
     
     - parameter presented:  被显示视图
     - parameter presenting: 展示视图
     - parameter source:
     
     - returns: 谁来负责
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    /**
     告诉系统如何动画,展示消失都会调用这个方法
     
     - parameter transitionContext: 上下文,存放动画的一些参数
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 判断是否展示
        if isPresented
        { // 展示中
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            transitionContext.containerView()?.addSubview(toView)
            toView.transform = CGAffineTransformMakeScale(1.0, 0.0)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                // 还原
                toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
                
                
                
                }, completion: { (_) -> Void in
                    toView.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(true)
            })
            
        } else {// 未展示
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                // 压扁
                fromView.transform = CGAffineTransformMakeScale(1.0, 0.0000001)
                
                }, completion: { (_) -> Void in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
        }
    }

}
