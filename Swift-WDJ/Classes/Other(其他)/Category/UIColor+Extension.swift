//
//  UIColor+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

extension UIColor
{
    /// 根据十六进制颜色c字符串创建颜色
    ///
    /// - Parameter hexadecimal: 十六进制颜色字符串#开头或0X开头
    /// - Returns: UIColor
    open class func colorWithHexString(hexadecimal:String) -> UIColor
    {
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        
        if(cstr.hasPrefix("0X")) {
            cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")) {
            cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6) {
            return UIColor.white
        }
        
        var range = NSRange()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range)
        //g
        range.location = 2
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0
        var g :UInt32 = 0x0
        var b :UInt32 = 0x0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    
    open class func corlorWith(red:CGFloat,green:CGFloat,blue:CGFloat) -> UIColor
    {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue  / 255.0, alpha: 1)
    }
}
