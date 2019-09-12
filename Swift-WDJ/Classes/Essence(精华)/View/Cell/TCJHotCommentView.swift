//
//  TCJHotCommentView.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJHotCommentView: UIView {

    // MARK: - 数据模型
    
    open var hotCommentModel:TCJHotCommentModel? {
        didSet {
            TCJImageCacheManager.shared.imageForKey(key: hotCommentModel?.user?.profileImage, size: CGSize(width: 30, height: 30), backgroundColor: backgroundColor ?? UIColor.white, isUserIcon: true) { (image) in
                self.userIconImageView.image = image
            }
            
            userNameLabel.text = hotCommentModel?.user?.userName
            contentTextLabel.text = (hotCommentModel?.voiceUrl != "" && hotCommentModel?.voiceUrl != nil) ? "[语音]" : hotCommentModel?.content
        }
    }
    
    // MARK: - 私有属性
    
    /// 用户头像
    @IBOutlet private weak var userIconImageView: UIImageView!
    /// 用户名称
    @IBOutlet private weak var userNameLabel: UILabel!
    /// 内容
    @IBOutlet private weak var contentTextLabel: UILabel!

}

// MARK: - 其他方法

extension TCJHotCommentView
{
    /// xib创建对象方法
    open class func hotCommentView() -> TCJHotCommentView
    {
        return Bundle.main.loadNibNamed("TCJHotCommentView", owner: nil, options: nil)?.last as! TCJHotCommentView
    }
}
