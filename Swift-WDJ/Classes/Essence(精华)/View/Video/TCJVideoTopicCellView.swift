//
//  TCJVideoTopicCellView.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJVideoTopicCellView: UIView {

    // MARK: - 视图模型
    
    open var topicViewModel:TCJTopicViewModel? {
        didSet {
            playCountLabel.text = topicViewModel?.playCountStr
            playDurationLabel.text = topicViewModel?.videoTimeStr
            TCJImageCacheManager.shared.imageForKey(key: topicViewModel?.imageURL, size: CGSize(width: kScreenWidth - 2 * kTopicCellMargin, height: topicViewModel?.imageHeight ?? 0), backgroundColor: backgroundColor ?? UIColor.white,isLongPicture:true) { (image) in
                self.backgroundImageView.image = image
            }
        }
    }
    
    // MARK: - 事件监听
    
    @IBAction private func playVideoAction(_ sender: UIButton)
    {
        guard let topicViewModel = topicViewModel else {
            return
        }
        
        // 发布通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kTopicCellDidTapNotification), object: nil, userInfo: [kTopicTypeKey:TCJTopicType.Video,kTopicViewModelKey: topicViewModel])
    }
    
    // MARK: - 私有属性
    
    /// 播放时长
    @IBOutlet private weak var playDurationLabel: UILabel!
    /// 播放次数
    @IBOutlet private weak var playCountLabel: UILabel!
    /// 背景图片
    @IBOutlet private weak var backgroundImageView: UIImageView!

}

// MARK: - 其他方法

extension TCJVideoTopicCellView
{
    /// xib创建对象方法
    open class func videoTopicCellView() -> TCJVideoTopicCellView
    {
        return Bundle.main.loadNibNamed("TCJVideoTopicCellView", owner: nil, options: nil)?.last as! TCJVideoTopicCellView
    }
}
