//
//  MainViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/22/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        
        tabBar.tintColor = UIColor.orangeColor()
        
        addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
        addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        
        
        
        
    }
    /**
     初始化子控制器
     
     - parameter childController: 自控制器
     - parameter title:           控制器标题
     - parameter imageName:       控制器图片名称
     */
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        // 0 创建控制器
//        let cls:AnyClass? = NSClassFromString(childControllerName)
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        
        let vcCls = cls as! UIViewController.Type
        
        let vc = vcCls.init()
        
        // 1.1 设置首页 tabbar对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.title = title
        
//        childController.navigationItem.title = title
        // 2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
        // 3.将导航控制添加到当前控制器上
        addChildViewController(nav)
    }

}
