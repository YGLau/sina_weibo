//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/22/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

/// 通知
let YGSwitchRootViewControllerKey = "YGSwitchRootViewControllerKey"


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidEnterBackground(application: UIApplication) {
        // 清空过期数据
        StatusDAO.cleanStatuses()
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        SQLiteManager.shareManager().openDB("status.sqlite")
        
        // 1.创建 window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        // 2.创建根控制器
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        // 进行一些全局设置
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        // 注册一个通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(switchRootViewController), name: YGSwitchRootViewControllerKey, object: nil)
        
        return true
    }
    
    func switchRootViewController(note:NSNotification) {
        if note.object as! Bool {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     *  判断是否有新版本
     */
    private func isNewUpdate() -> Bool {
        // 1.获取当前软件的版本号 --> info.plist
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        // 2.获取以前的软件版本号 --> 从本地文件中读取(以前自己存储的)
        let sandboxVersion = NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        // 3.比较当前版本号和以前版本号
        if currentVersion.compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            // 3.1如果当前>以前 --> 有新版本
            // 3.1.1存储当前最新的版本号
            // iOS7以后就不用调用同步方法了
            NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: "CFBundleShortVersionString")
            
            return true
            
        }
        // 3.2如果当前< | ==  --> 没有新版本
        return false
    }
    /**
     显示默认的控制器
     */
    private func defaultController() -> UIViewController {
        
        // 判断用户是否登录
        if UserAccount.userLogin() { // 登录
            if isNewUpdate() {
                return NewFeatureViewController()
            } else {
                return WelcomeViewController()
            }
            
        } else { // 没登录
             return MainViewController()
        }
        
    }

    


}

