//
//  Status.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/29/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
import SDWebImage

class Status: NSObject {
    // 微博创建时间
    var created_at: String?
    {
        didSet{
            // "Thu Mar 31 09:31:11 +0800 2016"
            // 1.字符串to时间
            let DateStr = NSDate.dateFromStr(created_at!)
            // 2.获取格式化后的字符串
            created_at = DateStr.descDate
        }
    }
    /// 微博ID
    var id:Int = 0
    /// 微博信息内容
    var text:String?
    /// 微博来源
    var source:String?
    {
        didSet{
            // <a href=\"http://app.weibo.com/t/feed/4fuyNj\" rel=\"nofollow\">即刻笔记</a>
            // source = "<a href=\"http://weibo.com/\" rel=\"nofollow\">\U5fae\U535a weibo.com</a>"
            // 截取字符串
            if let str = source {
                if str == "" { // 如果为空直接返回
                    return
                }
                // 1.获取开始的位置
                let startLoaction = (str as NSString).rangeOfString(">").location + 1
                // 2.获取截取的长度
                let length = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startLoaction
                // 3.截取
                source = "来自" + (str as NSString).substringWithRange(NSMakeRange(startLoaction, length))
            }
        }
    }
    /// 配图数组
    var pic_urls:[[String: AnyObject]]?
    {
        didSet{
            // 初始化数组
            storedPicURLs = [NSURL]()
            // 遍历配图数组,取出所有图片的路径
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] {
                    // 将字符串转为 url 保存到数组中
                    storedPicURLs?.append(NSURL(string: urlStr as! String)!)
                }
            }
            
        }
    }
    /**
     保存当前微博所有的配图的 url
     */
    var storedPicURLs: [NSURL]?
    
    // 用户信息
    var user: User?
    
    
    /**
     *  加载微博数据
     */
    class func loadStatuses(finished: (models:[Status]?, error:NSError?) ->()) {
        let path = "2/statuses/home_timeline.json"
        let params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) in
//            print(JSON)
            // 1.取出statuses key对应的数组 (存储的都是字典)
            // 2.遍历数组, 将字典转换为模型
            let models = dict2Model(JSON!["statuses"] as! [[String: AnyObject]])
            // 3.缓存微博配图
            cacheStatusImage(models, finished: finished)
            
            }) { (_, error) in
                print(error)
                finished(models: nil, error: error)
                
        }
        
        
    }
    /**
     缓存配图
     */
    class func cacheStatusImage(list: [Status], finished: (models: [Status]?, error:NSError?) -> ()) {
        
        // 1.创建一个组
        let group = dispatch_group_create()
        
        // 2.缓存图片
        for status in list {
            guard let urls  = status.storedPicURLs else {
                continue
            }
            
            for url in status.storedPicURLs! {
                // 将当前的下载操作添加到组中
                dispatch_group_enter(group)
                
                // 缓存图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) in
                    // 离开当前组
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 2.当所有图片都下载完毕再通过闭包通知调用者
//        dispatch_group_notify(group, dispatch_get_main_queue()) {
//            // 能够来到这个地方, 一定是所有图片都下载完毕
//            finished(models: list, error: nil)
//        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 能够来到这个地方, 一定是所有图片都下载完毕
            finished(models: list, error: nil)
        }
        
    }
    
    /**
     *  字典数组转模型数组
     */
    class func dict2Model(list:[[String: AnyObject]]) -> [Status] {
        
        var models = [Status]()
        for dict in list {
            models.append(Status(dict: dict))
        }
        
        return models
        
    }
    /**
     *  字典转模型
     */
    init(dict: [String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        // 1.判断当前是否正在给微博字典中的user字典赋值
        if "user" == key {
            // 2.根据user key对应的字典创建一个模型
            user = User(dict: value as! [String: AnyObject])
            return
        }
        // 3,调用父类方法, 按照系统默认处理
        super.setValue(value, forKey: key)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 打印当前模型
    var properties = ["created_at", "id", "text", "source", "pic_urls"]
    
    override var description: String {
        let dict = dictionaryWithValuesForKeys(properties)
        
        return "\(dict)"
        
    }
    
    

}
