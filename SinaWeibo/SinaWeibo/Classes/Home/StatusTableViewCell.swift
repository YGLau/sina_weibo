//
//  StatusTableViewCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    var status: Status? {
        didSet {
            contentLabel.text = status?.text
            sourceLabel.text = "刚刚"
            timeLabel.text = "2016-03-29 15:50"
            nameLabel.text = status?.user?.name
            
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            // 认证图片
            verifiedView.image = status?.user?.vertifiedImage
            // 会员图标
            vipView.image = status?.user?.mbrankImage
        }
    }

    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 去除选中样式
        selectionStyle = UITableViewCellSelectionStyle.None
        // 初始化子控件
        setupWedget()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     初始化子控件
     */
    private func setupWedget() {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomBar)
        
        // 2.布局子控件
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        
        let width = UIScreen.mainScreen().bounds.size.width
        bottomBar.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))

        bottomBar.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: contentView, size: nil, offset: CGPoint(x: -10, y: -10))
    }
    
    // MARK: - 懒加载
    // 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    // 认证图标
    private lazy var verifiedView: UIImageView = {
        let vV = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
        
        return vV
        
    }()
    // 昵称
    private lazy var nameLabel: UILabel = {
        let nl = UILabel.createLabel(textColor: UIColor.orangeColor(), fontSize: 12.0)
        return nl
    }()
    // 会员图标
    private lazy var vipView: UIImageView = {
        let vipV = UIImageView(image: UIImage(named: "common_icon_membership"))
        return vipV
    }()
    // 时间
    private lazy var timeLabel: UILabel = {
        let tl = UILabel.createLabel(textColor: UIColor.darkGrayColor(), fontSize: 12.0)
        return tl
    }()
    // 来源
    private lazy var sourceLabel: UILabel = {
        let sl = UILabel.createLabel(textColor: UIColor.darkGrayColor(), fontSize: 12.0)
        return sl
    }()
    // 正文
    private lazy var contentLabel: UILabel = {
        let cl = UILabel.createLabel(textColor: UIColor.blackColor(), fontSize: 15.0)
        cl.numberOfLines = 0
        cl.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
        return cl
        
    }()
    // 底部工具条
    private lazy var bottomBar: BottomBar = BottomBar()

}

class BottomBar: UIView {
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
        xmg_HorizontalTile([retweetBtn, commentBtn, likeBtn], insets: UIEdgeInsetsMake(0, 0, 0, 0))
        
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
