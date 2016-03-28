//
//  NewFeatureViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/28/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "newFeature"

class NewFeatureViewController: UICollectionViewController {
    
    let pageCount = 4
    
    // 创建布局
    let layout = NewfeatureLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        cell.imageIndex = indexPath.item
        return cell
    }
    /**
     cell显示完毕后调用
     */
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath)
        // 拿到当前 Cell 显示的索引
        let currentIndex = collectionView.indexPathsForVisibleItems().last!
        // 判断是否会最后一页
        // 拿到当前页对应索引的 cell
        let currentCell = collectionView.cellForItemAtIndexPath(currentIndex) as! NewFeatureCell
        if currentIndex.item == (pageCount - 1) {
            
            // 让 Cell 执行动画
            currentCell.startAnimation()
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item != (pageCount - 1) {
            
            (cell as! NewFeatureCell).startBtn.hidden = true
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

class NewFeatureCell: UICollectionViewCell {
    
    /// 新特性图片
    private lazy var iconView: UIImageView = {
        return UIImageView()
    }()
    /// 开始按钮
    private lazy var startBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"new_feature_finish_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"new_feature_finish_button_Highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(startBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        // 隐藏
        btn.hidden = true
        
        return btn
    }()
     /// 进入微博按钮点击
    func startBtnClick() {
        print(#function)
    }
    
    var imageIndex:Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // 初始化子控件
        setupChildWidget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    /**
     初始化子控件
     */
    private func setupChildWidget() {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startBtn)
        // 2.布局子控件
        iconView.frame = bounds
        startBtn.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: contentView, size: nil, offset: CGPoint(x: 0, y: -160))
        
    }
    
    /// 按钮动画
    func startAnimation() {
        
        startBtn.hidden = false
        // 动画
        startBtn.userInteractionEnabled = false
        startBtn.transform = CGAffineTransformMakeScale(0.0, 0.0)
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue:0), animations: {
            // 清空形变
            self.startBtn.transform = CGAffineTransformIdentity
            
            }) { (_) in
                
                self.startBtn.userInteractionEnabled = true
        }

    }
}

class NewfeatureLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        
        // 设置布局属性
        itemSize = UIScreen.mainScreen().bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        // 滚动方向 水平滚动
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 分页
        self.collectionView?.pagingEnabled = true
        // 水平滚动条
        self.collectionView?.showsHorizontalScrollIndicator = false
        // 弹簧效果
        self.collectionView?.bounces = false
        
    }
}
