//
//  NSDate+Category.swift
//  SinaWeibo
//
//  Created by 刘勇刚 on 3/31/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

extension NSDate {
    
    /**
     字符串转时间
     */
    class func dateFromStr(time:String) ->NSDate {
        // 1.将服务器返回给我们的时间字符串转换为NSDate
        // 1.1.创建formatter
        let fmt = NSDateFormatter()
        // 1.2.设置时间的格式
        fmt.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
        // 1.3设置时间的区域(真机必须设置, 否则可能不能转换成功)
        fmt.locale = NSLocale(localeIdentifier: "en")
        // 1.4转换字符串, 转换好的时间是去除时区的时间
        let date = fmt.dateFromString(time)!
        
        return date
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var descDate:String {
        
        let calendar = NSCalendar.currentCalendar()
        // 1.判断是否是今天
        if calendar.isDateInToday(self) {
            // 1.0获取当前时间和系统时间之间的差距(秒数)
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            // 1.1是否是刚刚
            if delta < 60 {
                return "刚刚"
            }
            // 1.2 多少分钟以前
            if delta < 60 * 60 {
                return "\(delta/60)分钟前"
            }
            // 1.3 多少小时以前
            return "\(delta/(60*60))小时前"
        }
        // 2.判断是否是昨天
        var fmt = "HH:mm"
        if calendar.isDateInYesterday(self) {
            // 昨天 HH:mm
            fmt = "昨天:" + fmt
        } else {
            // 3.一年内
            fmt = "MM-dd" + fmt
            
            // 4.去年以上的
            let cmps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if cmps.year > 1 {
                fmt = "yyyy-" + fmt
            }
            
        }
        
        // 5.按照指定的格式将时间转换为字符串
        // 5.1.创建formatter
        let formatter = NSDateFormatter()
        // 5.2.设置时间的格式
        formatter.dateFormat = fmt
        // 5.3设置时间的区域(真机必须设置, 否则可能不能转换成功)
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 5.4格式化
        let DateStr = formatter.stringFromDate(self)
        
        return DateStr

        
    }
    
}
