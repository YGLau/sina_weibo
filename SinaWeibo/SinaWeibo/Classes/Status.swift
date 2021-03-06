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
            storedLargePicURLs = [NSURL]()
            // 遍历配图数组,取出所有图片的路径
            for dict in pic_urls! {
                if let urlStr = dict["thumbnail_pic"] as? String {
                    // 1.将字符串转为 url 保存到数组中
                    storedPicURLs?.append(NSURL(string: urlStr)!)
                    
                    // 2.处理大图
                    let largeURLStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    storedLargePicURLs?.append(NSURL(string: largeURLStr)!)
                    
                }
            }
            
        }
    }
    /**
     保存当前微博所有的配图的 url
     */
    var storedPicURLs: [NSURL]?
    
     /// 保存当前所有配图“大图”的url
    var storedLargePicURLs:[NSURL]?
    
    // 用户信息
    var user: User?
    /**
     转发微博
     */
    var retweeted_status: Status?
    
    // 如果有转发, 原创就没有配图
    /// 定义一个计算属性, 用于返回原创获取转发配图的URL数组
    var pictureURLs: [NSURL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedPicURLs : storedPicURLs
    }
    
    /// 定义一个计算属性, 用于返回原创或者转发配图的大图URL数组
    var largePictureURLs: [NSURL]?
    {
        return retweeted_status != nil ? retweeted_status?.storedLargePicURLs : storedLargePicURLs
    }
    /**
     加载微博数据
     */
    class func loadStatuses(since_id: Int, max_id: Int, finished: (models: [Status]?, error: NSError?) -> ()) {
        
        StatusDAO.loadStatuses(since_id, max_id: max_id) { (array, error) in
            
            if array == nil {
                finished(models: nil, error: error)
                return
            }
            
            if error != nil {
                finished(models: nil, error: error)
                return
            }
            // 字典转模型
            let models = dict2Model(array!)
            
            // 缓存微博配图
            cacheStatusImage(models, finished: finished)
        }
    }

    /**
     缓存配图
     */
    class func cacheStatusImage(list: [Status], finished: (models: [Status]?, error:NSError?) -> ()) {
        
        if list.count == 0 {
            finished(models: list, error: nil)
            return
        }
        
        // 1.创建一个组
        let group = dispatch_group_create()
        
        // 2.缓存图片
        for status in list {
            guard let _  = status.pictureURLs else {
                continue
            }
            
            for url in status.pictureURLs! {
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
        dispatch_group_notify(group, dispatch_get_main_queue()) {
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
        // 2.判断是否是转发微博，如果是就自己处理
        if "retweeted_status" == key {
            retweeted_status = Status(dict: value as! [String : AnyObject])
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
