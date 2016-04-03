//
//  PhotoBrowserViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/3/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {
    
    
    var currentIndex: Int?
    var pictureURLs: [NSURL]?
    
    init(index: Int, urls: [NSURL]) {
        currentIndex = index
        pictureURLs = urls
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupWedgets()
    }
    /**
     初始化子控件
     */
    private func setupWedgets() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        // 2.布局
        closeBtn.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: 100, height: 30), offset: CGPoint(x: 10, y: -10))
        saveBtn.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: view, size: CGSize(width: 100, height: 30), offset: CGPoint(x: -10, y: -10))
        collectionView.frame = UIScreen.mainScreen().bounds
    }
    
    func closeBtnClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveBtnClick() {
        print(#function)
    }
    
    //MARK: - 懒加载
    private lazy var closeBtn: UIButton = {
        let btn = UIButton.createPhotoBrowserButton(withTitle: "关闭", target: self, action: #selector(closeBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy var saveBtn: UIButton = {
        let btn = UIButton.createPhotoBrowserButton(withTitle: "保存", target: self, action: #selector(saveBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    

}
