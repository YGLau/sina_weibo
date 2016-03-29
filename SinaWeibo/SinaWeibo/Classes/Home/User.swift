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
    {
        didSet{
            if let urlStr = profile_image_url {
                imageURL = NSURL(string: urlStr)
            }
        }
    }
    
     /// 保存头像的URL
    var imageURL: NSURL?
    
    
    // 是否是认证
    var verified: Bool = false
    
    // 用户认证的类型 -1:没有认证, 0, 认证用户, 2, 3, 5: 企业认证,220: 达人
    var verified_type: Int = -1
        {
        didSet{
            switch verified_type {
            case 0:
                vertifiedImage = UIImage(named: "avatar_vip")
            case 2, 3, 5:
                vertifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                vertifiedImage = UIImage(named: "avatar_grassroot")
            default:
                vertifiedImage = nil
            }
        }
    }
        /// 用户当前的认证图片
    var vertifiedImage: UIImage?
    
    var mbrank: Int = 0
        {
        didSet{
            if mbrank > 0 && mbrank < 7 {
                 mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            }
        }
    }
        /// 用户的会员等级
    var mbrankImage: UIImage?
    
    
    
    // 字典转模型
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    var properties = ["id", "name", "profile_image_url", "verified", "verified_type", "imageURL"]
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        return "\(dict)"
    }
    

}
