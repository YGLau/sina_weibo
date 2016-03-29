//
//  User.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class User: NSObject {
    // 用户 ID
    var id: Int = 0
    /// 好友显示名称
    var name:String?
    
    // 用户头像地址(中国), 50 * 50 像素
    var profile_image_url: String?
    
    // 是否是认证
    var verified: Bool = false
    
    // 用户认证的类型 -1:没有认证, 0, 认证用户, 2, 3, 5: 企业认证,220: 达人
    var verified_type: Int = -1
    
    // 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    

}
