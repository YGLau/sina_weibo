//
//  PhotoBrowserCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/3/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SDWebImage

protocol photoBrowserCellDelegateProtocol: NSObjectProtocol {
    
    func photoBrowserCellDidClick(cell: PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate: photoBrowserCellDelegateProtocol?
    
    var imageURL: NSURL?
    {
        didSet{
            // 1.重置属性
            reset()
            
            // 2.显示菊花
            activity.startAnimating()
            
            pictureView.sd_setImageWithURL(imageURL) { (image, _, _, _) in
                // 3.隐藏菊花
                self.activity.stopAnimating()
                
                self.setImageViewPosition()
            }
        }
    }
    /**
     重置scrollView的一些属性
     */
    private func reset() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        pictureView.transform = CGAffineTransformIdentity
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
        
        // 根据宽高比计算高度
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
        contentView.addSubview(activity)
        // 2.布局
        scrollView.frame = UIScreen.mainScreen().bounds
        activity.center = contentView.center
        
        
        // 3.处理缩放
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        //4.监听图片点击
        pictureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeVc)))
        pictureView.userInteractionEnabled = true
    }
    
    func closeVc() {
//        print(#function)
        photoBrowserCellDelegate?.photoBrowserCellDidClick(self)
    }
    //MARK: - 懒加载
    // 图片
    lazy var pictureView: UIImageView = UIImageView()
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoBrowserCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return pictureView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        var offsetX = (UIScreen.mainScreen().bounds.width - (view?.frame.size.width)!) * 0.5
        var offsetY = (UIScreen.mainScreen().bounds.height - (view?.frame.size.height)!) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        
    }
}
