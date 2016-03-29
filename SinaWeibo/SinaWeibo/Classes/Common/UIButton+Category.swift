//
//  UIButton+Category.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

extension UIButton {
    
    class func createButton(WithTitle title:String, imageName name:String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: name), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        return btn
        
    }
    
}
