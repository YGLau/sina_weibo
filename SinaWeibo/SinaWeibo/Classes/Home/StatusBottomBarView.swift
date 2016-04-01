//
//  StatusBottomBarView.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/1/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusBottomBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化三个按钮
        setChildWedget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     初始化子控件
     */
    private func setChildWedget() {
        // 1. 添加按钮
        addSubview(retweetBtn)
        addSubview(commentBtn)
        addSubview(likeBtn)
        // 2. 布局
        xmg_HorizontalTile([retweetBtn, commentBtn, likeBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    /// 转发按钮
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton.createButton(WithTitle: "11", imageName: "timeline_icon_retweet")
        return btn
    }()
    /// 评论按钮
    private lazy var commentBtn: UIButton = {
        let btn = UIButton.createButton(WithTitle: "205", imageName: "timeline_icon_comment")
        return btn
        
    }()
    /// 赞按钮
    private lazy var likeBtn: UIButton = {
        let btn = UIButton.createButton(WithTitle: "422", imageName: "timeline_icon_unlike")
        btn.setImage(UIImage(named: "timeline_icon_like"), forState: UIControlState.Selected)
        return btn
    }()
    
    

}
