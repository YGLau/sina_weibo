//
//  VisitorView.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/23/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

protocol VisitorViewDelegate:NSObjectProtocol {
    // 登录回调
    func loginBtnDidClick()
    // 注册回调
    func registerDidClick()
    
}

class VisitorView: UIView {
    
    weak var delegate:VisitorViewDelegate?

    /**
     设置未登录界面
     
     - parameter isHome:    是否主页
     - parameter imageName: 图片名称
     - parameter message:   文字内容
     */
    func setupVisitorInfo(isHome:Bool, imageName:String, message:String)
    {
        
        bgImageView.hidden = !isHome // 不是首页就隐藏
        
        homeIcon.image = UIImage(named:imageName)
        
        textlabel.text = message
        
        // 是否首页
        if isHome
        {
            startAnimation()
        }
    }
    
    private func startAnimation()
    {
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置一些属性
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        anim.duration = 20
        anim.removedOnCompletion = false;
        // 将动画添加到图层上
        bgImageView.layer.addAnimation(anim, forKey: nil)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加子控件
        addSubview(bgImageView)
        addSubview(maskBgView)
        addSubview(homeIcon)
        addSubview(textlabel)
        addSubview(loginBtn)
        addSubview(registerBtn)
        
        // 布局子控件
        // 背景
        bgImageView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        // 小房子
        homeIcon.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        // 文字 label
        textlabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: bgImageView, size: nil)
        // 文字按钮宽度
        let widthCons = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224)
        addConstraint(widthCons)
        // 注册按钮
        registerBtn.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: textlabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        // 登录按钮
        loginBtn.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: textlabel, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 0, y: 20))
        
        // 设置蒙版
        maskBgView.xmg_Fill(self)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 懒加载
    private lazy var bgImageView:UIImageView = {
        // 背景图片
        let bg = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        
        return bg
    }()
    
    private lazy var textlabel:UILabel = {
        let textLabel = UILabel()
        textLabel.text = "打附加赛可垃圾分类考试的减肥了快速的减肥两款手机的两款手机立刻"
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.darkGrayColor()
        
        return textLabel
    }()
    
    private lazy var homeIcon:UIImageView = {
        let homeIcon = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        
        return homeIcon
    }()
    /// 登录按钮
    private lazy var loginBtn:UIButton = {
        let loginBtn = UIButton(type: UIButtonType.Custom)
        loginBtn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        loginBtn.setTitle("登录", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return loginBtn
    }()
    /// 注册按钮
    private lazy var registerBtn:UIButton = {
        let registerBtn = UIButton(type: UIButtonType.Custom)
        registerBtn.setTitle("注册", forState: UIControlState.Normal)
        registerBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        registerBtn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        registerBtn.addTarget(self, action: #selector(registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        
        return registerBtn
    }()
    
    private lazy var maskBgView:UIImageView = {
        let maskBgView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return maskBgView
    }()
    
    // MARK: - 按钮点击方法
    func loginBtnClick ()
    {
//        print(__FUNCTION__)
        // 掉代理的回调方法
        delegate?.loginBtnDidClick()
    }
    
    func registerBtnClick ()
    {
//        print(__FUNCTION__)
        // 掉代理的回调方法
        delegate?.registerDidClick()
    }

}
