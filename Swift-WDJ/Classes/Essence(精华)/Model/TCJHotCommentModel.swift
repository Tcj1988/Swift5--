//
//  TCJHotCommentModel.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import MJExtension

@objcMembers class TCJHotCommentModel: NSObject {
    /// 热评内容
    var content:String?
    /// 点赞数
    var likeCount:Int = 0
    /// 语音热评Url
    var voiceUrl:String?
    /// 用户
    var user:TCJUserModel?
}

extension TCJHotCommentModel
{
    override class func mj_replacedKey(fromPropertyName121 propertyName: String!) -> Any! {
        if propertyName == "voiceUrl" {
            return "voiceuri"
        } else {
            return (propertyName as NSString).mj_underlineFromCamel()
        }
    }
}
