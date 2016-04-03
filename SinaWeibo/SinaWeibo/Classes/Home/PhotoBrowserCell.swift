//
//  PhotoBrowserCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/3/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserCell: UICollectionViewCell {
    
    var imageURL: NSURL?
    {
        didSet{
            pictureView.sd_setImageWithURL(imageURL) { (image, _, _, _) in
//                let size = self.disPlaySize(image)
//                self.pictureView.frame = CGRect(origin: CGPointZero, size: size)
                self.setImageViewPosition()
            }
        }
    }
    
    /**
     调整图片的显示位置
     */
    private func setImageViewPosition() {
        // 1.拿到按照宽高比计算之后的图片大小
        let size = self.disPlaySize(pictureView.image!)
        // 2.判断图片的高度, 是否大于屏幕的高度
        if size.height < UIScreen.mainScreen().bounds.size.height {
            // 2.1小于 短图 --> 设置边距, 让图片居中显示
            pictureView.frame = CGRect(origin: CGPointZero, size: size)
            // 居中
            let y = (UIScreen.mainScreen().bounds.size.height - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        } else {
            // 2.2大于 长图 --> y = 0 
            pictureView.frame = CGRect(origin: CGPointZero, size: size)
            scrollView.contentSize = size
            
        }
        
        
    }
    
    private func disPlaySize(image: UIImage) -> CGSize {
        // 1.拿到图片的宽高比
//        let scale = image.size.width / image.size.height
        
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.size.width
        let height = width * image.size.height / image.size.width
        return CGSize(width: width, height: height)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupWedget()
    }
    
    /**
     布局子控件
     */
    private func setupWedget() {
        // 1.添加
        contentView.addSubview(scrollView)
        // 将图片添加到scrollView上
        scrollView.addSubview(pictureView)
        // 2.布局
        scrollView.frame = UIScreen.mainScreen().bounds
    }
    
    //MARK: - 懒加载
    // 图片
    private lazy var pictureView: UIImageView = UIImageView()
    private lazy var scrollView: UIScrollView = UIScrollView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
