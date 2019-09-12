//
//  Bundle+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import Foundation

extension Bundle
{
    /// 命名空间
    open var nameSpace:String? {
        guard let progectName = (infoDictionary?[kCFBundleNameKey as String] as? String) else {
            return nil
        }
        
        return progectName + "."
    }
    
    /// 应用程序名称
    open var appName:String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
}
