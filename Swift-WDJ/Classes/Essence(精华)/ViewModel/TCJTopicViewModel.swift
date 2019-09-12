//
//  TCJTopicViewModel.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJTopicViewModel {
    /// 用户的名字
    open var name:String? {
        return topicModel?.name
    }
    
    /// 用户的头像
    open var profileImage:String? {
        return topicModel?.profileImage
    }
    
    /// 帖子的文字内容
    open var text:String? {
        return topicModel?.text
    }
    
    /// 帖子审核通过的时间
    open var passtime:String? {
        return topicModel?.passtime
    }
    
    /// 是否有热评
    open var isHasHotComment:Bool {
        return topicModel?.topCmt != nil
    }
    
    /// 热评数据模型
    open var hotCommentModel:TCJHotCommentModel? {
        return topicModel?.topCmt
    }
    
    /// 是否是GIF
    open var isGIF:Bool {
        return topicModel?.isGif == true
    }
    
    /// 图片URL地址
    open var imageURL:String? {
        return topicModel?.imageURL
    }
    
    /// 是否是长图
    open var isLongPicture:Bool {
        return topicModel!.height > kScreenHeight
    }
    
    /// 音频资源
    open var voiceURL:String? {
        return topicModel?.voiceuri
    }
    
    /// 视频资源
    open var videoURL:String? {
        return topicModel?.videouri
    }
    
    /// 帖子id
    open var topicId:Int {
        return topicModel?.timeId ?? 0
    }
    
    /// 赞
    private(set) open var likeStr:String?
    /// 踩
    private(set) open var unlikeStr:String?
    /// 分享
    private(set) open var shareStr:String?
    /// 评论
    private(set) open var commentStr:String?
    
    /// 行高
    private(set) open var rowHeight:CGFloat = 0
    
    /// 帖子类型
    private(set) open var type:TCJTopicType
    
    /// 图片高度
    private(set) open var imageHeight:CGFloat = 0
    
    /// 播放次数
    private(set) open var playCountStr:String?
    /// 视频时长
    private(set) open var videoTimeStr:String?
    /// 声音时长
    private(set) open var voiceTimeStr:String?
    
    // MARK: - 构造方法
    
    /// 帖子模型
    private var topicModel:TCJTopicModel?
    
    init(model:TCJTopicModel)
    {
        topicModel = model
        type = TCJTopicType(rawValue: model.type)!
        
        // 设置属性值
        likeStr = topicModel?.ding.toThousandString()
        unlikeStr = topicModel?.cai.toThousandString()
        shareStr = topicModel?.repost.toThousandString()
        commentStr = topicModel?.comment.toThousandString()
        
        imageHeight = (kScreenWidth - 2 * kTopicCellMargin) / model.width * model.height
        imageHeight = imageHeight > 200 ? 200 : ceil(imageHeight)
        
        playCountStr = topicModel?.playcount.toThousandString().appending("次播放")
        videoTimeStr = timeDurationToString(duration: topicModel?.videotime ?? 0)
        voiceTimeStr = timeDurationToString(duration: topicModel?.voicetime ?? 0)
        
        rowHeight = calculateRowHeight()
    }
}

// MARK: - 其他方法

private extension TCJTopicViewModel
{
    
    /// 计算行高
    func calculateRowHeight() -> CGFloat
    {
        var height:CGFloat = 0
        
        // 顶部视图高度
        height += kTopicCellTopViewHeight
        
        if let text = text {
            // 正文高度
            height += (kTopicCellMargin + ((text as NSString).boundingRect(with: CGSize(width: kScreenWidth - 2 * kTopicCellMargin, height: 200), options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: kContentTextFontSize)], context: nil).size.height))
        }
        
        if let _ = topicModel?.imageURL {
            // 图片高度
            height += (kTopicCellMargin + imageHeight)
        }
        
        if let _ = hotCommentModel {
            // 热评高度
            height += (kTopicCellMargin + kTopicCellHotCommentViewHeight)
        }
        
        // 底部视图
        height += (kTopicCellMargin + kTopicCellBottomViewHeight)
        
        return ceil(height)
    }
    
    
    /// 将播放时长转换为字符串
    ///
    /// - Parameter duration: 播放时长
    /// - Returns: String
    func timeDurationToString(duration:Int) -> String
    {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes,seconds)
    }
}
