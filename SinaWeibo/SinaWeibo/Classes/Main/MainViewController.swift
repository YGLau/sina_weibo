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
        
//        // 1.创建首页
//        let home = HomeTableViewController()
//        // 1.1 设置首页 tabbar对应的数据
//        home.tabBarItem.image = UIImage(named: "tabbar_home")
//        home.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
//        home.tabBarItem.title = "首页"
//        
//        home.navigationItem.title = "首页"
//        // 2.给首页包装一个导航控制器
//        let nav = UINavigationController()
//        nav.addChildViewController(home)
//        // 3.将导航控制添加到当前控制器上
//        addChildViewController(nav)
//        
//        let message = MessageTableViewController()
//        message.tabBarItem.image = UIImage(named: "tabbar_message_center")
//        message.tabBarItem.selectedImage = UIImage(named: "tabbar_message_center_highlighted")
//        message.tabBarItem.title = "消息"
//        let nav2 = UINavigationController()
//        nav2.addChildViewController(message)
//        addChildViewController(nav2)
        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "广场", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
        
        
    }
    /**
     初始化子控制器
     
     - parameter childController: 自控制器
     - parameter title:           控制器标题
     - parameter imageName:       控制器图片名称
     */
    private func addChildViewController(childController: UIViewController, title:String, imageName:String) {
        
        // 1.1 设置首页 tabbar对应的数据
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.title = title
        
//        childController.navigationItem.title = title
        // 2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        // 3.将导航控制添加到当前控制器上
        addChildViewController(nav)
    }

}
