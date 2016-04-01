//
//  StatusTopView.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/1/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusTopView: UIView {
    
    var status: Status?
        {
        didSet{
            // 来源
            sourceLabel.text = status?.source
            // 创建时间
            timeLabel.text = status?.created_at
            // 昵称
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupChildWedgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     初始化子控件
     */
    private func setupChildWedgets() {
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        // 2.布局
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: self, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        
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



}
