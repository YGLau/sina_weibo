//
//  UserAccount.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/26/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    // 用于调用 access_token ,接口授权后的 access_token
    var access_token: String?
    // access_token 的生命周期 单位是秒
    var expires_in:NSNumber?
    // 当前授权的 uid
    var uid:String?
    
    override init() {
        
    }
    
    init(dict: [String:AnyObject]) {
        access_token = dict["access_token"] as? String
        expires_in = dict["expires_in"] as? NSNumber
        uid = dict["uid"] as? String
    }
    
    override var description: String {
        // 1. 定义属性数组
        let properties = ["access_token", "expires_in", "uid"]
        // 2. 根据属性数组,将属性转为字典
        let dict = self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转为字符串
        return "\(dict)"
        
        
    }

}
