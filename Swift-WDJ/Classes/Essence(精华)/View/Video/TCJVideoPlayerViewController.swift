//
//  TCJVideoPlayerViewController.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJVideoPlayerViewController: UIViewController {

    // MARK: - 私有属性
    
    private var topicViewModel:TCJTopicViewModel
    
    private var player:VGPlayer = VGPlayer()
    
    // MARK: - 构造方法
    
    init(topicViewModel:TCJTopicViewModel) {
        self.topicViewModel = topicViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        TCJPrint("我去了")
    }
    
    // MARK: - 控制器生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        // 状态栏设置 自定义转场动画后 控制器无法再管理状态栏 需要设置这个属性
        modalPresentationCapturesStatusBarAppearance = true
        preparePlayVideo()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        player.pause()
    }

}

// MARK: - 其他方法

extension TCJVideoPlayerViewController
{
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 准备播放视频
    private func preparePlayVideo() -> Void
    {
        guard let urlString = topicViewModel.videoURL,
            let videoURL = URL(string: urlString) else {
                return
        }
        
        // 设置视频源
        player.replaceVideo(videoURL)
        // 设置代理
        player.delegate = self
        player.displayView.delegate = self
        // 设置标题
        player.displayView.titleLabel.text = nil
        // 添加视频视图
        view.addSubview(player.displayView)
        // 自动布局
        player.displayView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.center.equalTo(view)
            make.height.equalTo(view.snp.width).multipliedBy(3.0 / 4.0)
        }
    }
}

// MARK: - VGPlayerDelegate

extension TCJVideoPlayerViewController: VGPlayerDelegate
{
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError)
    {
        TCJPrint("播放失败\(error)")
    }
}

// MARK: - VGPlayerViewDelegate

extension TCJVideoPlayerViewController: VGPlayerViewDelegate
{
    func vgPlayerView(didTappedClose playerView: VGPlayerView)
    {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
//    func vgPlayerView(didDisplayControl playerView: VGPlayerView)
//    {
//        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
//    }
}
