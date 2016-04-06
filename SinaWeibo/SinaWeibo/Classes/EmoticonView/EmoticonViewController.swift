//
//  EmoticonViewController.swift
//  表情键盘界面布局
//
//  Created by 刘勇刚 on 4/4/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

let EmoticonCellIdentifier = "EmoticonCell"

class EmoticonViewController: UIViewController {
    
    /// 定义一个闭包属性, 用于传递选中的表情模型
    var emoticonDidSelectedCallBack: (emoticon: Emoticon) -> ()
    
    init(callBack: (emoticon: Emoticon) ->()) {
        
        self.emoticonDidSelectedCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
        // 1.初始化子控件
        setupWedgets()
    }
    
    private func setupWedgets() {
        
        // 1.添加
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        // 2.布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let dict = ["collectionView": collectionView, "toolbar": toolbar]
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-[toolbar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)
        
        
    }
    
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let col = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
        // 注册cell
        col.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: EmoticonCellIdentifier)
        col.dataSource = self
        col.delegate = self
        return col
    }()
    
    private lazy var toolbar: UIToolbar = {
        let bar = UIToolbar()
        bar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        var index = 0
        for title in ["最近", "默认", "emoji", "浪小花"] {
            let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(itemClick))
            
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        bar.items = items
        return bar
    }()
    private lazy var packages: [EmoticonPackage] = EmoticonPackage.packageList
    
    func itemClick(item: UIBarButtonItem)  {
        
//        print(item.tag)
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
    }
}

extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // 有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return packages.count
    }
    // 每组有多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return packages[section].emoticons?.count ?? 0
    }
    // 返回怎样的Cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 取出Cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonCellIdentifier, forIndexPath: indexPath) as! EmoticonCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.greenColor() : UIColor.redColor()
        // 取出对应组
        let package = packages[indexPath.section]
        // 取出对应组对应的模型
        let emoticon = package.emoticons![indexPath.item]
        cell.emotion = emoticon
        
        return cell
    }
    // 选中某一个Cell是调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        emoticon.times += 1
        packages[0].appendEmoticons(emoticon)
//        packages[0].appendEmoticons(emoticon)
        
        emoticonDidSelectedCallBack(emoticon: emoticon)
        
        
    }
    
}

class EmoticonCell: UICollectionViewCell {
    
    var emotion: Emoticon?
    {
        didSet{
            // 1.判断是否是图片表情
            if emotion?.chs != nil {
                
                emojiBtn.setImage(UIImage(contentsOfFile: emotion!.imagePath!), forState: UIControlState.Normal)
                
            }else {
                // 防止重用
                emojiBtn.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 2.设置emoji表情
            // 注意: 加上??可以防止重用
            emojiBtn.setTitle(emotion?.emojiStr ?? "", forState: UIControlState.Normal)
            
            // 3.判断是否删除按钮
            if emotion!.isRemoveBtn {
                emojiBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emojiBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
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
    
    private func setupWedget() {
        
        contentView.addSubview(emojiBtn)
        emojiBtn.backgroundColor = UIColor.whiteColor()
        emojiBtn.frame = CGRectInset(contentView.bounds, 4, 4)
        
    }
    
    //MARK: - 懒加载
    private lazy var emojiBtn: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        btn.userInteractionEnabled = false
        return btn
    }()
}
///MARK: - 自定义布局
class EmoticonLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1. 设置Cell的相关属性
        let width = (collectionView?.bounds.size.width)! / 7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        let y = ((collectionView?.bounds.height)! - 3 * width) * 0.499
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
    }
    
}