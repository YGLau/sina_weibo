//
//  HomeTableViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/22/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    // 定义一个变量保存当前是否展开
    var isPresented:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        

        // 设置导航条
        setupNav()
        
        
    }
    private func setupNav() {
        // 设置导航条的未登录按钮
        // 1.左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: "leftBtnClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightBtnClick")
        // 2.中间的 view
        navigationItem.titleView = titleView
    }

    private lazy var titleView:titleButton = {
        let titleBtn = titleButton()
        titleBtn.setTitle("首页标题", forState: UIControlState.Normal)
        
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return titleBtn
    }()
    
    func titleBtnClick(btn:titleButton)
    {
//        print(__FUNCTION__)
        btn.selected = !btn.selected
        // 弹出菜单
        let sb = UIStoryboard(name:"PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        vc?.transitioningDelegate = self
        // 自定义 modal 样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftBtnClick()
    {
        print(__FUNCTION__)
    }
    
    func rightBtnClick()
    {
        print(__FUNCTION__)
    }
    

}
// MARK: - UIViewControllerTransitioningDelegate
extension HomeTableViewController:UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning
{
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return PopoverPresentationController(presentedViewController:presented, presentingViewController:presenting)
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
                
                
                toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
                }, completion: { (_) -> Void in
                    toView.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(true)
            })
            
        } else {// 未展示
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            transitionContext.containerView()?.addSubview(fromView)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
                
                }, completion: { (_) -> Void in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
            
            
        }
        
        
        
    }
}
