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
        print(__FUNCTION__)
        btn.selected = !btn.selected
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
