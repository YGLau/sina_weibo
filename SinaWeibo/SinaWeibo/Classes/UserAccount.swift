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
    
    //MARK: - 保存和读取
    /**
     *  保存授权模型
     */
    func saveAccount() {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        print("filePath\(filePath)")
        
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
        

        
    }
    /**
     加载授权模型
     
     - returns: 用户模型
     */
    func loadAccount() -> UserAccount? {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        let filePath = (path as NSString).stringByAppendingPathComponent("account.plist")
        
        let account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
        
        return account
        
    }
    
    // MARK: - 将对象写进文件里
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    // 从文件中读取对象
    required init?(coder aDecoder:NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
    }
    
}
