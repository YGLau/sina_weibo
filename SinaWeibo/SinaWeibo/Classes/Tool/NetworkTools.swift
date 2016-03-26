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

}
