//
//  UIImage+Category.swift
//  图片布局
//
//  Created by 刘勇刚 on 4/6/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleImageFromImage(width: CGFloat) -> UIImage {
        
        let height = width * size.height / size.width
        
        // 按比例绘制一张新的图片
        let currSize = CGSize(width: width, height: height)
        // 开始图形上下文
        UIGraphicsBeginImageContext(currSize)
        // 绘制
        drawInRect(CGRect(origin: CGPointZero, size: currSize))
        // 获得图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
