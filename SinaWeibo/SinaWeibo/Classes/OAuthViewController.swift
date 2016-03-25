//
//  OAuthViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/25/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController, UIWebViewDelegate {
    
    private let WB_Client_ID = "2500508880"
    private let WB_Redirect_URI = "http://www.520it.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 加载授权页面
        loadAuthPage()
        
        webView.delegate = self
        
        
    }
    /// 加载授权页面
    private func loadAuthPage()  {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Client_ID)&redirect_uri=\(WB_Redirect_URI)"
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        
    }
    
    override func loadView() {
        view = webView
        title = "勇刚的微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        
    }
    /// 关闭
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - 懒加载
    private lazy var webView:UIWebView = UIWebView()
    
    //MARK: - UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
        
        return true
    }

}
