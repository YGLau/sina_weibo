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
                let size = self.disPlaySize(image)
                self.pictureView.frame = CGRect(origin: CGPointZero, size: size)
            }
        }
    }
    
    private func disPlaySize(image: UIImage) -> CGSize {
        // 1.拿到图片的宽高比
        let scale = image.size.width / image.size.height
        
        // 2.根据宽高比计算高度
        let width = UIScreen.mainScreen().bounds.size.width
        let height = width / scale
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
        contentView.addSubview(pictureView)
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
