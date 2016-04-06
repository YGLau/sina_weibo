//
//  ComposeViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/4/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

class ComposeViewController: UIViewController {
    
        /// 保存图片选择器的高度
    var photoViewHeightCons: NSLayoutConstraint?
    
    var tooBarbottomCons: NSLayoutConstraint?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册通知监听键盘的弹出或隐藏
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyBoardDidChangeFrame), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        addChildViewController(emojiVC)
        addChildViewController(photoPickerVC)
        
        // 1.初始化导航条
        setupNav()
        
        // 2.初始化textView
        setupInputView()
        
        // 3.初始化图片选择控制器
        setupPictureView()
        
        // 3.初始化导航条
        setupToolBar()
        
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
    监听键盘frame改变
     */
    func keyBoardDidChangeFrame(notification: NSNotification) {
        // 拿到键盘最终frame
        let frame = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"]!.CGRectValue
        let duration = notification.userInfo!["UIKeyboardAnimationDurationUserInfoKey"]!.doubleValue
        let curve = notification.userInfo!["UIKeyboardAnimationCurveUserInfoKey"]!.integerValue
        
        let height = UIScreen.mainScreen().bounds.size.height
        tooBarbottomCons?.constant = frame.origin.y - height
        UIView.animateWithDuration(duration) {
            
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if photoViewHeightCons?.constant == 0 {
            textView.becomeFirstResponder()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // 退出键盘
        textView.resignFirstResponder()
    }
    
    private func setupNav() {
        
        // 1.添加子控件
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(closeVc))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendStatus))
        // “发送”默认不能点
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 中间的视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel()
        label1.text = "发送微博"
        label1.font = UIFont.systemFontOfSize(15)
        label1.sizeToFit()
        titleView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFontOfSize(13)
        label2.sizeToFit()
        titleView.addSubview(label2)
        
        // 2.布局2个label
        label1.xmg_AlignInner(type: XMG_AlignType.TopCenter, referView: titleView, size: nil)
        label2.xmg_AlignInner(type: XMG_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
        
        
    }
    
    func closeVc() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /**
     发送微博
     */
    func sendStatus() {
        
        let text = textView.emoticonAttributedText()
        let image = photoPickerVC.pickedPicArr.first
        NetworkTools.shareNetworkTools().sendStatus(text, image: image, successCallback: { (status) in
            SVProgressHUD.showSuccessWithStatus("成功666！")
            self.closeVc()
            }) { (error) in
                print(error)
                SVProgressHUD.showErrorWithStatus("卧槽，失败了！")
        }
        
    }
    /**
     初始化textView
     */
    private func setupInputView() {
        // 1.添加子控件
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        // 2.布局
        textView.xmg_Fill(view)
        placeholderLabel.xmg_AlignInner(type: XMG_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 7))
        
    }
    
    /**
     初始化图片选择控制器
     */
    private func setupPictureView() {
        // 1.添加
        view.insertSubview(photoPickerVC.view, belowSubview: toolBar)
        // 2.布局
        let width = UIScreen.mainScreen().bounds.width
        let height: CGFloat = 0
        let cons = photoPickerVC.view.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: width, height: height))
        
        photoViewHeightCons = photoPickerVC.view.xmg_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    /**
     设置底部工具条
     */
    private func setupToolBar() {
        
        // 1.添加子控件
        view.addSubview(toolBar)
        view.addSubview(tiplabel)
        // 2.布局
        let w = UIScreen.mainScreen().bounds.width
        let cons = toolBar.xmg_AlignInner(type: XMG_AlignType.BottomLeft, referView: view, size: CGSize(width: w, height: 44))
        tooBarbottomCons = toolBar.xmg_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        tiplabel.xmg_AlignVertical(type: XMG_AlignType.TopRight, referView: toolBar, size: nil, offset: CGPoint(x: -10, y: -10))
        
    }
    // MARK: - 底部工具条按钮点击监听
    func selectPicture() {
//        print(#function)
        // 退出键盘
        textView.resignFirstResponder()
        // 改变高度
        photoViewHeightCons?.constant = UIScreen.mainScreen().bounds.height * 0.6
    }
    
    func inputEmoticon() {
        //        print(#function)
        photoViewHeightCons?.constant = 0
        // 关闭键盘
        textView.resignFirstResponder()
        
        textView.inputView = (textView.inputView == nil) ? emojiVC.view : nil
        // 再召唤一下
        textView.becomeFirstResponder()
    }
    
    //MARK: - 懒加载
    private lazy var textView: UITextView = {
        
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(15)
        tv.delegate = self
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.lightGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()
        /// 工具条
    private lazy var toolBar: UIToolbar = {
        let tb = UIToolbar()
//        tb.backgroundColor = UIColor.greenColor()
        // 添加item
        var items = [UIBarButtonItem]()
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            
                            ["imageName": "compose_mentionbutton_background"],
                            
                            ["imageName": "compose_trendbutton_background"],
                            
                            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
                            
                            ["imageName": "compose_addbutton_background"]]
        for dict in itemSettings {
            
            let btn = UIButton()
            btn.setImage(UIImage(named: dict["imageName"]!), forState: UIControlState.Normal)
            btn.setImage(UIImage(named: dict["imageName"]! + "_highlighted"), forState: UIControlState.Highlighted)
            btn.sizeToFit()
            if dict["action"] != nil {
                btn.addTarget(self, action: Selector(dict["action"]!), forControlEvents: UIControlEvents.TouchUpInside)
            }
            let item = UIBarButtonItem(customView: btn)
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        tb.items = items
        
        return tb
    }()
    
        /// 提示剩余字数label
    private lazy var tiplabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.greenColor()
        return label
        }()
    // 表情控制器
    private lazy var emojiVC: EmoticonViewController = EmoticonViewController { [unowned self] (emoticon) in
        
        self.textView.insertEmoticon(emoticon)
    }
    private lazy var photoPickerVC: PhotoSelectorViewController = PhotoSelectorViewController()
    
    

}
//MARK: - TextView代理方法
private let maxTipLength = 140
extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
        // 当前输入的长度
        let count = textView.emoticonAttributedText().characters.count
        let result = maxTipLength - count
        tiplabel.textColor = (result > 0) ? UIColor.darkGrayColor() : UIColor.redColor()
        tiplabel.text = result == maxTipLength ? "" : "\(result)"
        
        
    }
}
