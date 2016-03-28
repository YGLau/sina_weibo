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
        
        return btn
    }()
    var imageIndex:Int = 0 {
        didSet {
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = bounds
        
        // 布局按钮
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H|[subView]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView":iconView]))
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V|[subView]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: <#T##[String : AnyObject]#>))
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
