//
//  PictureViewCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/1/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SDWebImage

let YGPictureViewCell = "YGPictureViewCell"

class StatusPictureView: UICollectionView {
    

    var status: Status?
        {
        didSet{
            
            reloadData()
        }
    }
    
    /// 计算配图尺寸
    func calculateImageSize() -> CGSize {
        
        // 1.取出配图个数
        let imageCount = status?.storedPicURLs?.count
        // 2.如果没有配图
        if imageCount == 0 || imageCount == nil {
            return CGSizeZero
        }
        // 3.如果一张图片就按真实尺寸显示
        if imageCount == 1 {
            // 3.1取出缓存的图片
            let key = status?.storedPicURLs!.first?.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            layout.itemSize = image.size
            // 3.2返回缓存图片的尺寸
            return image.size
        }
        
        // 4.如果有4张配图,田字格显示
        let width = 90
        let margin = 10
        layout.itemSize = CGSize(width: width, height: width)
        if imageCount == 4 {
            
            let viewWidth = width * 2 + margin
            return CGSize(width: viewWidth, height: viewWidth)
            
        }
        // 列数
        let colNum = 3
        // 行数
        let rowNum = (imageCount! + colNum - 1) / colNum
        
        let viewWidth = width * colNum + (colNum - 1) * margin
        let viewHeight = width * rowNum + (rowNum - 1) * margin
        
        return CGSize(width: viewWidth, height: viewHeight)
    }
    // 配图
    private var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    init() {

        super.init(frame: CGRectZero, collectionViewLayout: layout)
        // 初始化配图相关属性
        setupPictureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     初始化配图相关属性
     */
    private func setupPictureView() {
        // 1.注册 cell
        registerClass(PictureViewCell.self, forCellWithReuseIdentifier: YGPictureViewCell)
        // 2.设置数据源
        dataSource = self
        // 3.设置 cell之间的间隙
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // 4.设置配图的背景色
        backgroundColor = UIColor.darkGrayColor()
    }
    
    private class PictureViewCell: UICollectionViewCell {
        
        // 定义属性接受外界传来的数据
        var imageURL:NSURL?
            {
            didSet{
                pictureImageView.sd_setImageWithURL(imageURL!)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            // 初始化子控件
            setupWedget()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        /**
         初始化子控件
         */
        private func setupWedget() {
            
            // 1.添加子控件
            contentView.addSubview(pictureImageView)
            // 2.布局
            pictureImageView.xmg_Fill(contentView)
            
            
        }
        // MARK: - 懒加载
        private lazy var pictureImageView:UIImageView = UIImageView()
    }
    
}


extension StatusPictureView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取 cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YGPictureViewCell, forIndexPath: indexPath) as! PictureViewCell
        // 2.取出模型
        cell.imageURL = status?.storedPicURLs![indexPath.item]
        // 3.返回 cell
        return cell
    }
    
}
