//
//  ComposeViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/4/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.初始化导航条
        setupNav()
        
        // 2.初始化textView
        setupInputView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 叫出键盘
        textView.becomeFirstResponder()
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
    func sendStatus() {
        let path = "2/statuses/update.json"
        let params = ["access_token": UserAccount.loadAccount()?.access_token, "status": textView.text]
        
        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: nil, success: { (_, JSON) in
            
//            print(JSON)
            SVProgressHUD.showSuccessWithStatus("发送成功666...!")
            self.closeVc()
            
            }) { (_, error) in
                
//                print(error)
                SVProgressHUD.showErrorWithStatus("居然发送失败了？")
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
    
    //MARK: - 懒加载
    private lazy var textView: UITextView = {
        
        let tv = UITextView()
        tv.delegate = self
        
        return tv
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.lightGrayColor()
        label.text = "分享新鲜事..."
        return label
    }()

}

extension ComposeViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
