//
//  TCJVideoTopicTableViewCell.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJVideoTopicTableViewCell: TCJBaseTopicTableViewCell {

    // MARK: - 懒加载
    
    /// 图片视图
    private lazy var videoView = TCJVideoTopicCellView.videoTopicCellView()
    
    // MARK: - 视图模型
    override var topicViewModel: TCJTopicViewModel? {
        didSet {
            // 更新图片高度
            let height = topicViewModel?.imageHeight ?? 200
            videoView.snp.updateConstraints { (make) in
                make.height.equalTo(height).priority(.high)
            }
            
            // 设置图片
            videoView.topicViewModel = topicViewModel
        }
    }
    
    // MARK: - 设置界面
    
    override func setUpUI() {
        super.setUpUI()
        
        // 添加子控件
        addSubview(videoView)
        
        // 设置自动布局
        videoView.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(kTopicCellMargin)
            make.left.right.equalTo(contentLabel)
            make.height.equalTo(200).priority(.high)
        }
    }

}
