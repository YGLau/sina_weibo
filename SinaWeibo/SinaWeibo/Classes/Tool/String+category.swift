//
//  String+category.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/26/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

extension String {
    /**
     *  当前字符串拼接到 cache目录后面
     */
    func cacheDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     *  当前字符串拼接到 doc目录后面
     */
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString
        
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    /**
     *  当前字符串拼接到 tmp 目录后面
     */
    func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
        
    }
}