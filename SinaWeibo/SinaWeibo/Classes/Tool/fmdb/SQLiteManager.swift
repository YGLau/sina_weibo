//
//  SQLiteManager.swift
//  SQLite基本使用
//
//  Created by 刘勇刚 on 4/8/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class SQLiteManager: NSObject {
    
    private static var manager: SQLiteManager = SQLiteManager()
    
    // 创建一个单粒对象
    class func shareManager() -> SQLiteManager {
        return manager
    }
//
//    
    var dbQueue: FMDatabaseQueue?
//
    func openDB(DBName: String) {
        // 1.根据传入的数据库名称拼接数据库路径
        let path = DBName.docDir()
        print(path)
        
        // 2.创建数据库对象
        dbQueue = FMDatabaseQueue(path: path)
        
        // 创建表
        createTable()
        
    }
//
//    
    /**
     *  创建数据表
     */
    private func createTable()
    {
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Status( \n" +
            "statusId INTEGER PRIMARY KEY, \n" +
            "statusText TEXT, \n" +
            "userId INTEGER \n" +
        "); \n"
        
        // 2.执行SQL语句
        dbQueue!.inDatabase { (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        }
    }

}
