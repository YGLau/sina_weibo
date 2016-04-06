//
//  NetworkTools.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/26/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import AFNetworking
class NetworkTools: AFHTTPSessionManager {
    
    static let tools:NetworkTools = {
        
        let url = NSURL(string:"https://api.weibo.com/")
        let t = NetworkTools(baseURL:url)
        
        // 设置AFN能够接收的数据类型
        t.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        
        return t
        
    }()
    

    class func shareNetworkTools() -> NetworkTools {
        return tools
    }
    
    func sendStatus(text: String, image: UIImage?, successCallback: (status: Status) ->(), errorCallBack: (error: NSError) -> ()) {
        
        var path = "2/statuses/"
        let params = ["access_token": UserAccount.loadAccount()!.access_token!, "status": text]
        if image != nil { // 图文微博
            path += "upload.json"
            POST(path, parameters: params, constructingBodyWithBlock: { (formData) in
                
                // 1.将数据转为二进制
                let data = UIImagePNGRepresentation(image!)
                
                // 2.上传数据
                formData.appendPartWithFileData(data!, name: "pic", fileName: "abc.png", mimeType: "application/octet-stream")
                
                }, progress: nil, success: { (_, JSON) in
                    
                    successCallback(status: Status(dict: JSON as! [String : AnyObject]))
                    
                }, failure: { (_, error) in
                    
                    errorCallBack(error: error)
            })
        } else {
            
            path += "update.json"
            POST(path, parameters: params, progress: nil, success: { (_, JSON) in
                
                successCallback(status: Status(dict: JSON as! [String : AnyObject]))
                
            }) { (_, error) in
                
                errorCallBack(error: error)
            }
            
        }
        
    }

}
