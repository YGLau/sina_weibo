//
//  StatusDAO.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/8/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusDAO: NSObject {
    /**
     清空数据
     */
    class func cleanStatuses() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        let date = NSDate(timeIntervalSinceNow: -60)
        let dateStr = formatter.stringFromDate(date)
        
        // 定义sql
        let sql = "DELETE FROM T_Status WHERE createDate <= '\(dateStr)';"
        
        // 执行
        SQLiteManager.shareManager().dbQueue?.inDatabase({ (db) in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        })
        
    }
    
    class func loadStatuses(since_id: Int, max_id: Int, finished: ([[String: AnyObject]]?, error: NSError?) -> ()) {
        // 1.从本地数据库中获取
        loadCacheStatuses(since_id, max_id: max_id) { (array) in
            // 2.如果本地有, 直接返回
            if !array.isEmpty {
                print("从本地库中获取")
                finished(array, error: nil)
                return
            }
        }
        // 3.从网络获取
        let path = "2/statuses/home_timeline.json"
        var params = ["access_token":UserAccount.loadAccount()!.access_token!]
        
        // 下拉刷新
        if since_id > 0 {
            params["since_id"] = "\(since_id)"
        }
        
        // 上拉刷新
        if max_id > 0 {
            params["max_id"] = "\(max_id - 1)"
        }
        
        NetworkTools.shareNetworkTools().GET(path, parameters: params, progress: nil, success: { (_, JSON) in
            // 取出statuses key对应的数组 (存储的都是字典)
            let array = JSON!["statuses"] as! [[String: AnyObject]]
            // 4.将从网络获取的数据缓存起来
            cacheStatuses(array)
            finished(array, error: nil)
            StatusDAO.cacheStatuses(JSON!["statuses"] as! [[String: AnyObject]])
        }) { (_, error) in
            print(error)
            finished(nil, error: error)
        }
        
    }
    
    // 从数据库中加载缓存数据
    class func loadCacheStatuses(since_id: Int, max_id: Int, finished: ([[String: AnyObject]]) -> ()) {
        
        // 定义SQL语句
        var sql = "SELECT * FROM T_Status \n"
        if since_id > 0 {
            sql += "WHERE statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "WHERE statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC \n"
        sql += "LIMIT 20; \n"
        
        // 执行
        SQLiteManager.shareManager().dbQueue?.inDatabase({ (db) in
            // 查询数据
            let res = db.executeQuery(sql, withArgumentsInArray: nil)
            
            // 遍历取出查询到结果
            var statuses = [[String: AnyObject]]()
            while res.next() {
                // 取出数据库存储的一条微博字符串
                let dictStr = res.stringForColumn("statusText") as String
                // 将微博字符串转为微博字典
                let data = dictStr.dataUsingEncoding(NSUTF8StringEncoding)!
                let dict = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [String: AnyObject]
                statuses.append(dict)
            }
            
            // 返回数据
            finished(statuses)
        })
        
    }
    
    /**
     缓存微博数据
     
     - parameter statuses: 微博数组
     */
    class func cacheStatuses(statuses: [[String: AnyObject]]) {
        // 准备数据
        let userId = UserAccount.loadAccount()!.uid!
        
        // 定义SQL
        let sql = "INSERT OR REPLACE INTO T_Status" +
            "(statusId, statusText, userId)" +
            "VALUES" +
        "(?, ?, ?);"
        
        // 执行SQL
        SQLiteManager.shareManager().dbQueue?.inTransaction({ (db, rollback) in
            for dict in statuses {
                let statusId = dict["id"]!
                // JSON -> 二进制 -> 字符串
                let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
                let statusText = String(data: data, encoding: NSUTF8StringEncoding)!
                print(statusText)
                if !db.executeUpdate(sql, statusId, statusText, userId) {
                    // 如果插入数据失败，就回滚
                    rollback.memory = true
                    break
                }
            }
        })
        
    }

}
