//
//  HomeRefreshControl.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/2/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class HomeRefreshControl: UIRefreshControl {

    
    override init() {
        super.init()
        
        setupWedget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWedget() {
        
        // 1. 添加子控件
        addSubview(refreshView)
        // 2. 布局子控件
        refreshView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: CGSize(width: 170, height: 50))
        /*
         1.当用户下拉到一定程度的时候需要旋转箭头
         2.当用户上推到一定程度的时候需要旋转箭头
         3.当下拉刷新控件触发刷新方法的时候, 需要显示刷新界面(转轮)
         
         通过观察:
         越往下拉: 值就越小
         越往上推: 值就越大
         */
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
        
    }

    /// 定义变量记录是否需要旋转监听
    private var rotationArrowFlag = false
    /// 定义变量记录当前是否正在执行圈圈动画
    private var loadingViewAnimFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // 过滤掉大于0的数据
        if frame.origin.y >= 0 {
            return
        }
        // 判断是否已经触发刷新事件
        if refreshing && !loadingViewAnimFlag {
//            print("圈圈动画")
            loadingViewAnimFlag = true
            // 显示圈圈，并且执行动画
            refreshView.startLoadingViewAnim()
        }
        if frame.origin.y >= -50 && rotationArrowFlag{
//            print("翻转回来")
            rotationArrowFlag = false
            refreshView.rotationArrowImage(rotationArrowFlag)
            
        }
        else if frame.origin.y <= -50 && !rotationArrowFlag {
//            print("翻转")
            rotationArrowFlag = true
            refreshView.rotationArrowImage(rotationArrowFlag)
        }
        
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        // 关闭圈圈动画
        refreshView.stopLoadingViewAnim()
        // 复位圈圈动画标记
        loadingViewAnimFlag = false
    }
    //MARK: - 懒加载
    private lazy var refreshView: HomeRefreshView = HomeRefreshView.refreshView()
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }

}

class HomeRefreshView: UIView {
    // 箭头
    @IBOutlet weak var arrowImage: UIImageView!
    // 圈圈
    @IBOutlet weak var loadingView: UIImageView!
    // 下拉整体
    @IBOutlet weak var tipView: UIView!
    
    /**
     旋转箭头
     */
    func rotationArrowImage(flag: Bool) {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.2) { 
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, CGFloat(angle))
        }
        
    }
    
    /**
     圈圈动画
     */
    func startLoadingViewAnim() {
        tipView.hidden = true
        // 1.创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 2.设置动画相关属性
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        anim.removedOnCompletion = false
        // 3.将动画添加到图层上
        loadingView.layer.addAnimation(anim, forKey: nil)
        
    }
    /**
     停止动画
     */
    func stopLoadingViewAnim() {
        tipView.hidden = false
        loadingView.layer.removeAllAnimations()
    }
    /**
     返回一下个创建好的View
     */
    class func refreshView() -> HomeRefreshView {
        
        return NSBundle.mainBundle().loadNibNamed("HomeRefreshView", owner: nil, options: nil).last as! HomeRefreshView
        
    }
    
}
