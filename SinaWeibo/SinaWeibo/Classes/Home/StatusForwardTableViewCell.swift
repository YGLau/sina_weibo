//
//  StatusForwardTableViewCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/2/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusForwardTableViewCell: StatusTableViewCell {
    /**
     重写父类的方法
     */
    override func setupWedgets() {
        
        super.setupWedgets()
        
        // 1.添加子控件
        contentView.insertSubview(forwardBtn, belowSubview: pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardBtn)
        // 2.布局
        //2.1 布局转发背景
        forwardBtn.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -10, y: 10))
        forwardBtn.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: bottomBar, size: nil)
        
        //2.2 转发正文
        forwardLabel.text = "hsdah ofnjsjod[nfqweipfhreifhewchnld'skcnlsdkncosasfdge"
        forwardLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: forwardBtn, size: nil, offset: CGPoint(x: 10, y: 10))
        
        //2.3 重新调整转发配图的位置
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: forwardLabel, size: nil, offset: CGPoint(x: 0, y: 10))
        pictureViewWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureViewTopCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
    }
    
    // MARK: - 懒加载
    private lazy var forwardBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()
    private lazy var forwardLabel:UILabel = {
        let label = UILabel.createLabel(textColor: UIColor.darkGrayColor(), fontSize: 15.0)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
        return label
    }()

}
