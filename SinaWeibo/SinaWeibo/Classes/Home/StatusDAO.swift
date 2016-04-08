//
//  StatusDAO.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 4/8/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class StatusDAO: NSObject {
    
    class func loadStatus() {
        // 1.从本地数据库中获取
        // 2.如果本地有, 直接返回
        // 3.从网络获取
        // 4.将从网络获取的数据缓存起来
    }
    
    class func cacheStatuses(statuses: [[String: AnyObject]]) {
        // 准备数据
        let userId = UserAccount.loadAccount()!.uid!
        
        // 定义SQL
        let sql = "INSERT INTO T_Status" +
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
                if db.executeUpdate(sql, statusId, statusText, userId) {
                    // 如果插入数据失败，就回滚
                    rollback.memory = true
                }
            }
        })
        
        
    
    }

}
