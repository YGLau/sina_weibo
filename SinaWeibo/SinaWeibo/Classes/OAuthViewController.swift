//
//  OAuthViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/25/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    
    private let WB_App_Key = "2500508880"
    private let WB_App_Secret = "9060bd05295b6cd82f8db87f44f8e61d"
    private let WB_Redirect_URI = "http://www.520it.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 加载授权页面
        loadAuthPage()
        
        
        webView.delegate = self
        //请求
        // https://api.weibo.com/oauth2/authorize?client_id=123050457758183&redirect_uri=http://www.example.com/response&response_type=code
        
        //同意授权后会重定向
        // http://www.example.com/response&code=CODE
        
    }
    /// 加载授权页面
    private func loadAuthPage()  {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_URI)"
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
    

}

extension OAuthViewController:UIWebViewDelegate {
    
    //MARK: - UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        /*
         加载授权界面: https://api.weibo.com/oauth2/authorize?client_id=2624860832&redirect_uri=http://www.520it.com
         
         跳转到授权界面: https://api.weibo.com/oauth2/authorize
         
         授权成功: http://www.520it.com/?code=91e779d15aa73698cbbb72bc7452f3b3
         
         取消授权: http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
         */
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL?.absoluteString
        if !urlStr!.hasPrefix(WB_Redirect_URI) {
            return true
        }
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            print("授权成功!")
            // 取出已经授权的RequestToken
            // codeStr.endIndex是拿到code=最后的位置
            // 1.取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        } else {
            print("授权失败")
            close()
        }
        return false
    }
    /// 换取 AccessToken
    private func loadAccessToken(code:String) {
         // 1.定义路径
        let path = "oauth2/access_token"
         // 2.封装参数
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_Redirect_URI]
        // 3.发送 POST请求
        NetworkTools.shareNetworkTools().POST(path, parameters: params, progress: { (_) in
            
            }, success: { (_, JSON) in
                print(JSON)
            }) { (_, error) in
                print(error)
        }
        
    }
    

    
}
