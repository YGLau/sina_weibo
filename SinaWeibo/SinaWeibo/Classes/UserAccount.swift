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
    var expires_in:NSNumber? {
        didSet{
            // 根据过期的秒数, 生成真正地过期时间
            expires_date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    // 当前授权的 uid
    var uid:String?
    // 保存用户过期时间
    var expires_date:NSDate?
    
    // 用户头像
    var avatar_large: String?
    
    // 用户昵称
    var screen_name: String?
    
    override init() {
        
    }
    
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        print(key)
    }
    
    override var description: String {
        // 1. 定义属性数组
        let properties = ["access_token", "expires_in", "uid", "expires_date", "avatar_large", "screen_name"]
        // 2. 根据属性数组,将属性转为字典
        let dict = self.dictionaryWithValuesForKeys(properties)
        // 3.将字典转为字符串
        return "\(dict)"
        
        
    }
    /**
     发送网络请求,获取用户信息
     */
    func loadUserInfo(finish: (account:UserAccount?, error:NSError?) -> ()) {
        assert(access_token != nil, "没有授权")
        let path = "2/users/show.json"
        let params = ["access_token":access_token!, "uid":uid!]
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: { (_) in
            
            }, success: { (_, JSON) in
//                print(JSON)
                // 1.判断字典是否有值
                if let dict = JSON as? [String: AnyObject] {
                    self.screen_name = dict["screen_name"] as? String
                    self.avatar_large = dict["avatar_large"] as? String
                    // 保存用户信息
                    finish(account: self, error: nil)
                    return
                }
                
                finish(account: nil, error: nil)
            }) { (_, error) in
                
                finish(account: nil, error: error)
                
        }
    }
    
    /**
     记录用户是否登录
     */
    class func userLogin() -> Bool {
        return UserAccount.loadAccount() != nil
    }
    
    //MARK: - 保存和读取
    /**
     *  保存授权模型
     */
    static let filePath = "account.plist".cacheDir()
    func saveAccount() {
        
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
        
    }
    /**
     加载授权模型
     
     - returns: 用户模型
     */
    static var account: UserAccount?
    class func loadAccount() -> UserAccount? {

        // 1.判断是否已经加载过
        if account != nil {
            return account
        }
        
        // 2.加载授权模型
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? UserAccount
        
        // 3.判断授权信息是否过期
        if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
            // 过期
            return nil
        }
        
        return account
        
    }
    
    // MARK: - 将对象写进文件里
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    // 从文件中读取对象
    required init?(coder aDecoder:NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
}
