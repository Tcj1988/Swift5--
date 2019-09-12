//
//  TCJUserModel.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers class TCJUserModel: NSObject {
    /// 昵称
    var userName:String?
    /// 头像
    var profileImage:String?
}

// MARK: - MJExtension
extension TCJUserModel
{
    override class func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any! {
        if propertyName == "userName" {
            return "username"
        } else {
            return (propertyName as NSString).mj_underlineFromCamel()
        }
    }
}
