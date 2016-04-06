//
//  PhotoSelectorViewController.swift
//  图片布局
//
//  Created by 刘勇刚 on 4/6/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

private let PhotoCellSelectedIdentifier = "PhotoCell"
class PhotoSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWedget()
    }
    
    // 初始化界面
    private func setupWedget() {
        // 1. 添加子控件
        view.addSubview(collectionView)
        // 2.布局
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView" : collectionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView" : collectionView])
        view.addConstraints(cons)
    
    }
    
    //MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: photoSelectedFlowLayout())
        cv.registerClass(PhotoselectedCell.self, forCellWithReuseIdentifier: PhotoCellSelectedIdentifier)
        cv.dataSource = self
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    /**
     *  创建一个数组保存当前选中的图片
     */
    private lazy var pickedPicArr = [UIImage]()
    

}
//MARK: - UICollectionViewDataSource数据源方法
extension PhotoSelectorViewController: UICollectionViewDataSource, PhotoselectedCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickedPicArr.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print(indexPath.item)
        // 取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCellSelectedIdentifier, forIndexPath: indexPath) as! PhotoselectedCell
        cell.photoselectedCellDelegate = self
        // 取出模型
        cell.image = (pickedPicArr.count == indexPath.item) ? nil : pickedPicArr[indexPath.item]
        
        return cell
    }
    //MARK: - PhotoselectedCell的代理方法
    // 添加图片
    func photoselectedCellAddPhoto(cell: PhotoselectedCell) {
        
        // 判断能否打开照片库
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        // 创建图片控制器
        let vc = UIImagePickerController()
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
        
    }
    /**
     选中一张图片后调用
     
     - parameter picker:      触发的控制器
     - parameter image:       被选中的图片
     - parameter editingInfo: 编辑之后的图片
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 1.将选中的图片添加到数组中
        let width:CGFloat = 300
        let newimage = image.scaleImageFromImage(width)
        pickedPicArr.append(newimage)
        collectionView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    // 删除图片
    func photoselectedCellRemovePhoto(cell: PhotoselectedCell) {
        
        // 获取需要删除的索引
        let indexPath = collectionView.indexPathForCell(cell)
        pickedPicArr.removeAtIndex(indexPath!.item)
        // 刷新表格
        collectionView.reloadData()
        
    }
    
    
}

@objc
protocol PhotoselectedCellDelegate: NSObjectProtocol {
    
    optional func photoselectedCellAddPhoto(cell: PhotoselectedCell)
    optional func photoselectedCellRemovePhoto(cell: PhotoselectedCell)
}

class PhotoselectedCell: UICollectionViewCell {
    
    weak var photoselectedCellDelegate: PhotoselectedCellDelegate?
    
    var image: UIImage?
    {
        didSet{
            if image != nil {
                removeBtn.hidden = false
                addBtn.setBackgroundImage(image, forState: UIControlState.Normal)
                addBtn.userInteractionEnabled = false
            } else {
                removeBtn.hidden = true
                addBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                addBtn.userInteractionEnabled = true
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.brownColor()
        setupWedgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWedgets() {
        // 1.添加
        contentView.addSubview(addBtn)
        contentView.addSubview(removeBtn)
        // 2.布局
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[addBtn]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addBtn" : addBtn])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[addBtn]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["addBtn" : addBtn])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[removeBtn]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeBtn" : removeBtn])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[removeBtn]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeBtn" : removeBtn])
        contentView.addConstraints(cons)
        
    }
    // MARK: - 懒加载
    private lazy var addBtn:UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(addPictureClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    private lazy var removeBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(removePictureClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    //MARK: - 添加和删除图片
    func addPictureClick() {
//        print(#function)
        photoselectedCellDelegate?.photoselectedCellAddPhoto!(self)
    }
    func removePictureClick() {
//        print(#function)
        photoselectedCellDelegate?.photoselectedCellRemovePhoto!(self)
    }
}

class photoSelectedFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        let width: CGFloat = 90
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}

