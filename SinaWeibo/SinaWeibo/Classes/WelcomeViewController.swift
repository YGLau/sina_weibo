//
//  WelcomeViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/28/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {
        /// 头像的底部约束
    var bottomCons:NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.添加控制
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        // 2.布局子控件
        bgImageView.xmg_Fill(view)
        
        let cons = iconView.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: view, size: CGSize(width: 100, height: 100), offset: CGPoint(x: 0, y: -150))
        
         bottomCons = iconView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // label
        welcomeLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 20))
        
        // 3.设置用户头像
        if let iconUrl = UserAccount.loadAccount()?.avatar_large {
            let url = NSURL(string: iconUrl)!
            iconView.sd_setImageWithURL(url)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        bottomCons?.constant = -UIScreen.mainScreen().bounds.size.height - bottomCons!.constant
        
        // 执行动画
        UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue:0), animations: {
            // 头像
            self.iconView.layoutIfNeeded()
            
            }) { (_) in
                // 文本动画
                UIView.animateWithDuration(2.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: {
                     self.welcomeLabel.alpha = 1.0
                    }, completion: { (_) in
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(YGSwitchRootViewControllerKey, object: true)
                })
                
        }
    }
    
    /**
     *  背景
     */
    private lazy var bgImageView:UIImageView = {
        let bg = UIImageView(image: UIImage(named: "ad_background"))
        return bg
    }()
    
    /**
     *  头像
     */
    private lazy var iconView:UIImageView = {
        let icon = UIImageView(image: UIImage(named: "avatar_default_big"))
        icon.layer.cornerRadius = 50
        icon.clipsToBounds = true
        return icon
        
    }()

    /**
     *  "欢迎"文字
     */
    private lazy var welcomeLabel:UILabel = {
        let welLabel = UILabel()
        welLabel.text = "欢迎回来"
        welLabel.sizeToFit()
        welLabel.alpha = 0.0
        return welLabel
    }()

}
