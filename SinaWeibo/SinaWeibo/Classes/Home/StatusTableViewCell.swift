//
//  StatusTableViewCell.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SDWebImage

let YGPictureViewCell = "YGPictureViewCell"

class StatusTableViewCell: UITableViewCell {
    
    // 保存配图的宽和高约束
    var pictureViewWidthCons: NSLayoutConstraint?
    var pictureViewHeightCons: NSLayoutConstraint?
    
    var status: Status? {
        didSet {
            contentLabel.text = status?.text
            // 来源
            sourceLabel.text = status?.source
            // 创建时间
            timeLabel.text = status?.created_at
            // 昵称
            nameLabel.text = status?.user?.name
            
            if let url = status?.user?.imageURL {
                iconView.sd_setImageWithURL(url)
            }
            // 认证图片
            verifiedView.image = status?.user?.vertifiedImage
            // 会员图标
            vipView.image = status?.user?.mbrankImage
            
            // 设置配图尺寸
            //1.1 根据模型计算配图尺寸
            let size = calculateImageSize()
            //1.2 设置配图的尺寸
            pictureViewWidthCons?.constant = size.viewSize.width
            pictureViewHeightCons?.constant = size.viewSize.height
            //1.3 设置 Cell 的大小
            layout.itemSize = size.itemSize
            //1.4 刷新表格
            pictureView.reloadData()
            
        }
    }

    // 自定义一个类需要重写的init方法是 designated
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 去除选中样式
        selectionStyle = UITableViewCellSelectionStyle.None
        // 初始化子控件
        setupWedgets()
        // 初始化配图
        setupPictureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     初始化子控件
     */
    private func setupWedgets() {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(verifiedView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(bottomBar)
        contentView.addSubview(pictureView)
        /**
         iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
         verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x:5, y:5))
         nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
         vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
         timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
         sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
         contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
         
         let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
         
         pictureWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
         pictureHeightCons =  pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
         print("pictureWidthCons = \(pictureWidthCons)")
         print("pictureHeightCons = \(pictureHeightCons)")
         
         let width = UIScreen.mainScreen().bounds.width
         footerView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
         */
        // 2.布局子控件
        iconView.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: contentView, size: CGSize(width: 50, height: 50), offset: CGPoint(x: 10, y: 10))
        verifiedView.xmg_AlignInner(type: XMG_AlignType.BottomRight, referView: iconView, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 5, y: 5))
        nameLabel.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        vipView.xmg_AlignHorizontal(type: XMG_AlignType.TopRight, referView: nameLabel, size: CGSize(width: 14, height: 14), offset: CGPoint(x: 10, y: 0))
        timeLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: 10, y: 0))
        sourceLabel.xmg_AlignHorizontal(type: XMG_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: 10, y: 0))
        contentLabel.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: iconView, size: nil, offset: CGPoint(x: 0, y: 10))
        // 配图
        let cons = pictureView.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: contentLabel, size: CGSizeZero, offset: CGPoint(x: 0, y: 10))
        pictureViewWidthCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewHeightCons = pictureView.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
        
        let width = UIScreen.mainScreen().bounds.size.width
        bottomBar.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: width, height: 44), offset: CGPoint(x: -10, y: 10))
    }
    
     /// 计算配图尺寸
     private func calculateImageSize() -> (viewSize:CGSize, itemSize:CGSize) {
        // 1.取出配图个数
        let imageCount = status?.storedPicURLs?.count
        // 2.如果没有配图
        if imageCount == 0 || imageCount == nil {
            return (CGSizeZero, CGSizeZero)
        }
        // 3.如果一张图片就按真实尺寸显示
        if imageCount == 1 {
            // 3.1取出缓存的图片
            let key = status?.storedPicURLs!.first?.absoluteString
            let iamge = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key!)
            // 3.2返回缓存图片的尺寸
            return (iamge.size, iamge.size)
        }
        
        // 4.如果有4张配图,田字格显示
        let width = 90
        let margin = 10
        if imageCount == 4 {
            let viewWidth = width * 2 + margin
            return (CGSize(width: viewWidth, height: viewWidth), CGSize(width: width, height: width))
            
            
        }
        // 5.多张图片,九宫格显示
        // 列数
        // 4+ 3 - 1 / 3 = 2
        // 5 + 3 - 1 / 3 = 2
        // 6 + 3 - 1 / 3 = 2
        // 7 + 3 -1 / 3 = 3
        let colNum = 3
        // 行数
        let rowNum = (imageCount! + colNum - 1) / colNum
        
        let viewWidth = width * colNum + (colNum - 1) * margin
        let viewHeight = width * rowNum + (rowNum - 1) * margin
        
        return (CGSize(width: viewWidth, height: viewHeight), CGSize(width: width, height: width))
        
    }
    
     /// 初始化配图相关属性
    private func setupPictureView() {
        // 1.注册 cell
        pictureView.registerClass(pictureViewCell.self, forCellWithReuseIdentifier: YGPictureViewCell)
        // 2.设置数据源
        pictureView.dataSource = self
        // 3.设置 cell之间的间隙
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        // 4.设置配图的背景色
        pictureView.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - 懒加载
    // 头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        return iv
    }()
    // 认证图标
    private lazy var verifiedView: UIImageView = {
        let vV = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
        
        return vV
        
    }()
    // 昵称
    private lazy var nameLabel: UILabel = {
        let nl = UILabel.createLabel(textColor: UIColor.orangeColor(), fontSize: 12.0)
        return nl
    }()
    // 会员图标
    private lazy var vipView: UIImageView = {
        let vipV = UIImageView(image: UIImage(named: "common_icon_membership"))
        return vipV
    }()
    // 时间
    private lazy var timeLabel: UILabel = {
        let tl = UILabel.createLabel(textColor: UIColor.darkGrayColor(), fontSize: 12.0)
        return tl
    }()
    // 来源
    private lazy var sourceLabel: UILabel = {
        let sl = UILabel.createLabel(textColor: UIColor.darkGrayColor(), fontSize: 12.0)
        return sl
    }()
    // 正文
    private lazy var contentLabel: UILabel = {
        let cl = UILabel.createLabel(textColor: UIColor.blackColor(), fontSize: 15.0)
        cl.numberOfLines = 0
        cl.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.size.width - 20
        return cl
        
    }()
    // 配图
    private lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var pictureView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    // 底部工具条
    private lazy var bottomBar: BottomBar = BottomBar()

}

class BottomBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化三个按钮
        setChildWedget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     初始化子控件
     */
    private func setChildWedget() {
        // 1. 添加按钮
        addSubview(retweetBtn)
        addSubview(commentBtn)
        addSubview(likeBtn)
        // 2. 布局
        xmg_HorizontalTile([retweetBtn, commentBtn, likeBtn], insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
    }
        /// 转发按钮
    private lazy var retweetBtn: UIButton = {
        let btn = UIButton.createButton(WithTitle: "11", imageName: "timeline_icon_retweet")
        return btn
    }()
        /// 评论按钮
    private lazy var commentBtn: UIButton = {
        let btn = UIButton.createButton(WithTitle: "205", imageName: "timeline_icon_comment")
        return btn
        
    }()
        /// 赞按钮
    private lazy var likeBtn: UIButton = {
        let btn = UIButton.createButton(WithTitle: "422", imageName: "timeline_icon_unlike")
        btn.setImage(UIImage(named: "timeline_icon_like"), forState: UIControlState.Selected)
        return btn
    }()
}
//MARK: - tabelView 数据源
extension StatusTableViewCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.storedPicURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取 cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YGPictureViewCell, forIndexPath: indexPath) as! pictureViewCell
        // 2.取出模型
        cell.imageURL = status?.storedPicURLs![indexPath.item]
        // 3.返回 cell
        return cell
    }
    
}
// MARK: - 微博图片 Cell
class pictureViewCell: UICollectionViewCell {
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
    private lazy var pictureImageView:UIImageView = {
        let pic = UIImageView()
        return pic
    }()
}
