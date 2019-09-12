//
//  TCJPictureTopicCellView.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJPictureTopicCellView: UIView {

    // MARK: - 视图模型
    
    open var topicViewModel:TCJTopicViewModel? {
        didSet {
            seeBigPictureButton.isHidden = (topicViewModel?.isLongPicture == false)
            gifImageView.isHidden = (topicViewModel?.isGIF != true)
            TCJImageCacheManager.shared.imageForKey(key: topicViewModel?.imageURL, size: CGSize(width: kScreenWidth - 2 * kTopicCellMargin, height: topicViewModel?.imageHeight ?? 0), backgroundColor: backgroundColor ?? UIColor.white,isLongPicture:true) { (image) in
                self.backgroundImageView.image = image
            }
        }
    }
    
    // MARK: - 事件监听
    
    /// 查看大图事件
    @IBAction private func seeBigPictureAction()
    {
        guard let topicViewModel = topicViewModel else {
            return
        }
        
        // 发布通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kTopicCellDidTapNotification), object: nil, userInfo: [kTopicTypeKey:TCJTopicType.Picture,
                                                                                                                                   kTopicViewModelKey: topicViewModel])
    }
    
    // MARK: - 私有属性
    
    /// 查看大图按钮
    @IBOutlet weak var seeBigPictureButton: UIButton!
    /// 背景图片
    @IBOutlet private weak var backgroundImageView: UIImageView!
    /// gif标记
    @IBOutlet private weak var gifImageView: UIImageView!

}

// MARK: - 其他方法

extension TCJPictureTopicCellView
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(seeBigPictureAction)))
    }
    
    /// xib创建对象方法
    open class func pictureTopicCellView() -> TCJPictureTopicCellView
    {
        return Bundle.main.loadNibNamed("TCJPictureTopicCellView", owner: nil, options: nil)?.last as! TCJPictureTopicCellView
    }
}
