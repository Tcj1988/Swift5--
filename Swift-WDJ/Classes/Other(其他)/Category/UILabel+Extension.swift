//
//  UILabel+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

extension UILabel
{
    
    /// 便利构造方法
    ///
    /// - Parameters:
    ///   - text: 文本内容
    ///   - fontSize: 字体大小 默认15
    ///   - textColor: 文本颜色 默认lightGray
    ///   - textAlignment: 文本对齐方式 默认center
    convenience init(text:String,fontSize:CGFloat = 15,textColor:UIColor = UIColor.lightGray,textAlignment:NSTextAlignment = .center)
    {
        self.init()
        
        self.text = text
        self.textColor = textColor
        self.textAlignment = textAlignment
        font = UIFont.systemFont(ofSize: fontSize)
        numberOfLines = 0
        sizeToFit()
    }
}

