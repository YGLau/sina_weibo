//
//  BaseTableViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/23/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {
    
    // 定义一个变量保存用户当前是否登录
    var userLogin = UserAccount.userLogin()
    
    // 定义一个属性保存这个未登录界面
    var visitorView:VisitorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()
        
        
        
    }
    /**
     添加一个全局视图
     */
    func setupVisitorView() {
        // 初始化未登录界面
        let visitor = VisitorView()
        visitor.delegate = self
        view = visitor
        visitorView = visitor
        
        
    }
    
    // MARK: - VisitorViewDelegate
    func loginBtnDidClick() {
        let Oauth = OAuthViewController()
        let nav = UINavigationController(rootViewController: Oauth)
        presentViewController(nav, animated: true, completion: nil)
        
        
    }
    
    func registerDidClick() {
        // 注册
        print(NetworkTools.shareNetworkTools())
    }
    


}
