//
//  StatusTableViewCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    // 保存配图的宽和高约束
    var pictureViewWidthCons: NSLayoutConstraint?
    var pictureViewHeightCons: NSLayoutConstraint?
    
    var status: Status? {
        didSet {
            // 传值
            topView.status = status
            // 正文
            contentLabel.text = status?.text
            
            // 设置配图尺寸
            pictureView.status = status
            //1.1 根据模型计算配图尺寸
            let size = pictureView.calculateImageSize()
            //1.2 设置配图的尺寸
            pictureViewWidthCons?.constant = size.width
            pictureViewHeightCons?.constant = size.height
            
        }
    }

    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 去除选中样式
        selectionStyle = UITableViewCellSelectionStyle.None
        // 初始化子控件
        setupWedgets()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     初始化子控件
     */
    private func setupWedgets() {
        // 1.添加子控件
        // 顶部
        contentView.addSubview(topView)
        // 微博正文
        contentView.addSubview(contentLabel)
        // 配图
        contentView.addSubview(pictureView)
        // 底部
        contentView.addSubview(bottomBar)
        
        // 2.布局子控件
        let width = UIScreen.mainScreen().bounds.size.width
        // topView
        topView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: width, height: 60))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 10, y: 10))
        // 配图
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureViewWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        // 底部
        bottomBar.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 35), offset: CGPoint(x: -10, y: 10))
    }
    
    /**
     获取行号
     */
    func rowHeight(status: Status) -> CGFloat {
        // 1.为了能够调用didSet, 计算配图的高度
        self.status = status
        // 2.强制更新界面
        self.layoutIfNeeded()
        
        // 3.返回底部工具条的最大Y值
        return CGRectGetMaxY(bottomBar.frame)
    }
     
    
    //MARK: - 懒加载
    // 顶部View
    private lazy var topView:StatusTopView = StatusTopView()
    // 正文
    private lazy var contentLabel: UILabel = {
        let cl = UILabel.createLabel(textColor: UIColor.blackColor(), fontSize: 15.0)
        cl.numberOfLines = 0
        cl.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
        return cl
        
    }()
    // 配图
    private lazy var pictureView:StatusPictureView = StatusPictureView()
    // 底部工具条
    private lazy var bottomBar: StatusBottomBarView = StatusBottomBarView()

}


