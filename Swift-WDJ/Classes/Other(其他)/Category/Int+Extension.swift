//
//  Int+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

extension Int
{
    func toThousandString() -> String {
        var str:String
        if self < 10000 {
            str = "\(self)" // 小于1万
        } else{
            // 大于1万
            str = String(format: "%.2f", CGFloat(self) / CGFloat(10000))
            // 处理 2.00
            if str.hasSuffix(".00") {
                let location = (str as NSString).range(of: ".00").location
                str = (str as NSString).substring(to: location)
            } else if str.hasSuffix("0") {
                // 处理 2.20
                let index = str.index(str.endIndex, offsetBy: -1)
                str = String(str[..<index])
            }
            
            str += "万"
        }
        return str
    }
}
