//
//  PopoverPresentationController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/24/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    
    /**
     初始化方法, 用于创建负责转场动画的对象
     
     :param: presentedViewController  被展现的控制器
     :param: presentingViewController 发起的控制器, Xocde6是nil, Xcode7是野指针
     
     :returns: 负责转场动画的对象
     */
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    override func containerViewWillLayoutSubviews() {
        
        
        presentedView()?.frame = CGRectMake(100, 56, 200, 300)
        
        containerView?.insertSubview(coverView, atIndex: 0)
    }
    
    // 自定义视图遮罩
    // MARK: - 懒加载
    private lazy var coverView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        // 监听
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
