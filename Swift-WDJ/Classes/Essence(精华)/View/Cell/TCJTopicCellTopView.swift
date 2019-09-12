//
//  TCJTopicCellTopView.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJTopicCellTopView: UIView {
    
    // MARK: - 私有属性
    
    /// 用户头像
    @IBOutlet private weak var userIconImageView: UIImageView!
    /// 用户昵称
    @IBOutlet private weak var userNameLabel: UILabel!
    /// 发布时间
    @IBOutlet private weak var createTimeLabel: UILabel!
    
    // MARK: - 视图模型
    open var topicViewModel:TCJTopicViewModel?{
        didSet {
            TCJImageCacheManager.shared.imageForKey(key: topicViewModel?.profileImage, size: CGSize(width: kTopicCellUserIconWidth, height: kTopicCellUserIconWidth), backgroundColor: backgroundColor ?? UIColor.white, isUserIcon: true) { (image) in
                self.userIconImageView.image = image
            }
            
            userNameLabel.text = topicViewModel?.name
            createTimeLabel.text = topicViewModel?.passtime
        }
    }

}

// MARK: - 其他方法

extension TCJTopicCellTopView
{
    /// xib创建对象方法
    open class func topicCellTopView() -> TCJTopicCellTopView
    {
        return Bundle.main.loadNibNamed("TCJTopicCellTopView", owner: nil, options: nil)?.last as! TCJTopicCellTopView
    }
}
