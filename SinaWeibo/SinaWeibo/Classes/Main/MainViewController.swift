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
        
        // 1.创建 json 文件路径
        let filePath = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        // 2.通过路径创建 NSData
        if let jsonPath = filePath {
            let jsonData = NSData(contentsOfFile: jsonPath)
            // 3.序列化 json
            do{
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                // 4.遍历数组, 动态创建控制器
                for dict in dictArr as! [[String : String]]{
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            }catch
            {
                addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
                addChildViewController("NullViewController", title: "", imageName: "")
                addChildViewController("DiscoverTableViewController", title: "广场", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 设置加号按钮
        setupComposeBtn()
        
    }
    
    private func setupComposeBtn() {
        tabBar.addSubview(composeBtn)
        // 布局 compose的位置和尺寸
        let width = UIScreen.mainScreen().bounds.size.width / (CGFloat)(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
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
    
    // MARK: - 懒加载
    private lazy var composeBtn: UIButton = {
        let btn = UIButton()
        // 设置图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        // 设置背景图片
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        // 添加监听
        btn.addTarget(self, action: "addBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    // MARK: - 加号按钮点击
    func addBtnClick() {
        print(__FUNCTION__)
    }

}
