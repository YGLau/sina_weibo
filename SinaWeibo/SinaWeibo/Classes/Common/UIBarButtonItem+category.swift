//
//  UIBarButtonItem+category.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/23/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    // 类方法 创建一个导航栏上的按钮
    class func createBarButtonItem(imageName:String, target:AnyObject?, action:Selector) -> UIBarButtonItem
    {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        
        return UIBarButtonItem(customView: btn)
    }
}
