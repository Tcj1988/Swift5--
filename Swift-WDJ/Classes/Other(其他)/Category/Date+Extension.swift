//
//  Date+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import Foundation

/// 日期格式化器
private let kDateFormatter:DateFormatter = DateFormatter()

extension Date
{
    // 结构体中 要是有类方法 要使用static修饰
    
    /// 将日期转换为格式化字符串
    ///
    /// - Parameter sinceNow: 与当前时间的差 默认为0
    /// - Returns: String
    public static func dateToString(sinceNow:TimeInterval = 0) -> String
    {
        let date = Date(timeIntervalSinceNow: sinceNow)
        kDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        kDateFormatter.locale = Locale(identifier: "en")
        return kDateFormatter.string(from: date)
    }
    
    /// 将字符串转换为日期
    ///
    /// - Parameters:
    ///   - dateString: 日期字符串
    ///   - format: 日期格式
    /// - Returns: Date
    public static func stringToDate(dateString:String,format:String) -> Date?
    {
        kDateFormatter.dateFormat = format
        kDateFormatter.locale = Locale(identifier: "en")
        return kDateFormatter.date(from: dateString)
    }
    
    /// 返回当前日期的格式化字符串
    ///
    /// - Parameter format: 日期格式
    /// - Returns: String
    public func formatString(format:String) -> String
    {
        kDateFormatter.dateFormat = format
        kDateFormatter.locale = Locale(identifier: "en")
        return kDateFormatter.string(from: self)
    }
}
