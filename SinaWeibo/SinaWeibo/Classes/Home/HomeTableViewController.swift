//
//  HomeTableViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/22/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userLogin
        {
            visitorView?.setupVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 设置导航条
        setupNav()
        
        // 监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationChange), name: PopoverAnimatorWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationChange), name: PopoverAnimatorWillDismiss, object: nil)
        
    }
    
    func notificationChange() {
        //修改按钮的状态
        let titleBtn = navigationItem.titleView as! titleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    private func setupNav() {
        // 设置导航条的未登录按钮
        // 1.左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: #selector(leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: #selector(rightBtnClick))
        // 2.中间的 view
        navigationItem.titleView = titleView
    }

    private lazy var titleView:titleButton = {
        let titleBtn = titleButton()
        titleBtn.setTitle("首页标题 ", forState: UIControlState.Normal)
        
        titleBtn.addTarget(self, action: #selector(titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return titleBtn
    }()
    
    func titleBtnClick(btn:titleButton)
    {
//        btn.selected = !btn.selected
        // 弹出菜单
        let sb = UIStoryboard(name:"PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        
        // 让PopoverAnimator对象成为代理
//        vc?.transitioningDelegate = popoverAnimator
        // 自定义 modal 样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    func leftBtnClick()
    {
        print(#function)
    }
    
    func rightBtnClick()
    {
        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        presentViewController(vc!, animated: true, completion: nil)
    }
    
    // Mark: - 懒加载
//    private lazy var popoverAnimator:PopoverAnimator = {
//        let pa = PopoverAnimator()
//        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 300)
//        
//        return pa
//    }()
    

}

