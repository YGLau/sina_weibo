//
//  UILabel+Category.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

extension UILabel {
    class func createLabel(textColor color: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFontOfSize(fontSize)
        return label
    }
}
