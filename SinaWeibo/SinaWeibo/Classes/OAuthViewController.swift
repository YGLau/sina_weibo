//
//  OAuthViewController.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/25/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    
    private let WB_App_Key = "2500508880"
    private let WB_App_Secret = "9060bd05295b6cd82f8db87f44f8e61d"
    private let WB_Redirect_URI = "http://www.520it.com"

    override func viewDidLoad() {
        super.viewDidLoad()
        /// 加载授权页面
        loadAuthPage()
    
    }
    /// 加载授权页面
    private func loadAuthPage()  {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_URI)"
        let url = NSURL(string: urlString)
        
        let request = NSURLRequest(URL: url!)
        
        webView.loadRequest(request)
        webView.delegate = self
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

//MARK: - UIWebViewDelegate
extension OAuthViewController:UIWebViewDelegate {
    

    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1.判断是否是授权回调页面, 如果不是就继续加载
        let urlStr = request.URL?.absoluteString
        if !urlStr!.hasPrefix(WB_Redirect_URI) {
            return true
        }
        // 2.判断是否授权成功
        let codeStr = "code="
        if request.URL!.query!.hasPrefix(codeStr) {
            
            // 1.取出已经授权的RequestToken
            let code = request.URL!.query?.substringFromIndex(codeStr.endIndex)
            
            // 2.利用已经授权的RequestToken换取AccessToken
            loadAccessToken(code!)
        } else {
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
                
                // 1.字典转模型
                let account = UserAccount(dict: JSON as! [String: AnyObject])
                // 2.获取用户信息
                account.loadUserInfo({ (account, error) in
                    if account != nil {
                        account!.saveAccount()
                        // 去欢迎界面
                        NSNotificationCenter.defaultCenter().postNotificationName(YGSwitchRootViewControllerKey, object: false)
                        return
                    }
                    SVProgressHUD.showInfoWithStatus("网络不给力")
                })

            }) { (_, error) in
                SVProgressHUD.showErrorWithStatus("登录失败")
                self.close()
        }
        
    }
    
    // MARK: - 遮盖提示
    func webViewDidStartLoad(webView: UIWebView) {
        // 提示用户正在加载
        SVProgressHUD.showInfoWithStatus("正在加载...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭提示
        SVProgressHUD.dismiss()
    }
    

}
