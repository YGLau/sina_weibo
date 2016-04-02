//
//  HomeRefreshControl.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/2/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    
    override init() {
        super.init()
        
        setupWedget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWedget() {
        
        // 1. 添加子控件
        addSubview(refreshView)
        // 2. 布局子控件
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 60))
    }
    //MARK: - 懒加载
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()

}

class HomeRefreshView: UIView {
    /**
     返回一下个创建好的View
     */
    class func refreshView() -> HomeRefreshView {
        
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
        
    }
    
}
