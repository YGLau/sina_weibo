//
//  StatusNormalTableViewCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/2/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusNormalTableViewCell: StatusTableViewCell {


    override func setupWedgets() {
        
        super.setupWedgets()
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        
        pictureViewWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
    }

}
