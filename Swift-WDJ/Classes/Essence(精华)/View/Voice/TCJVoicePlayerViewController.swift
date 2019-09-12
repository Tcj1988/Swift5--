//
//  TCJVoicePlayerViewController.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import SDWebImage
import FreeStreamer

class TCJVoicePlayerViewController: UIViewController {

    // MARK: - 构造方法
    
    init(topicViewModel:TCJTopicViewModel)
    {
        self.topicViewModel = topicViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 设置界面
        setUpUI()
        // 注册通知
        registerNotification()
        // 播放音频
        audioController.play()
        // 设置图片
        setImageView()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        /// 停止定时器
        stopTimer()
    }
    
    deinit {
        TCJPrint("我去了")
    }
    
    // MARK: - 通知监听
    
    // 音频流播放状态发生变化
    @objc private func audioStreamStateChangeNotification(notification:Notification) -> Void
    {
        guard let dict = notification.userInfo else {
            return
        }
        
        let stateVaue = dict[FSAudioStreamNotificationKey_State] as! Int
        let state = FSAudioStreamState(rawValue: stateVaue)!
        switch (state) {
        case .fsAudioStreamRetrievingURL:
            TCJPrint("接收到数据...")
            if timer == nil {
                startTimer()
            }
        case .fsAudioStreamPlaying:
            TCJPrint("正在播放")
        case .fsAudioStreamFailed:
            TCJPrint("播放失败")
        case .fsAudioStreamPlaybackCompleted:
            TCJPrint("播放完成")
        default:
            break
        }
    }
    
    // MARK: - 事件监听
    
    /// 暂停播放按钮
    @IBAction private func playOrPauseAction(_ button: UIButton)
    {
        button.isSelected = !button.isSelected
        // audioController.pause()如果当前在播放 会暂停 如果当前暂停 会进行播放
        if button.isSelected {
            // 暂停状态 显示播放按钮
            audioController.pause()
        } else {
            // 播放状态 显示暂停按钮
            audioController.pause()
        }
    }
    
    /// slider正在拖动
    @IBAction private func progressSliderValueChanged(_ slider: UISlider)
    {
        // 停止定时器
        if timer != nil {
            stopTimer()
        }
        
        // 音频总时长
        let duration = audioController.activeStream.duration
        let totalTime = duration.minute * 60 + duration.second
        let currentTime = UInt32(Float(totalTime) * slider.value)
        // 更新当前播放时长
        currentTimeLabel.text = secondsToString(seconds: currentTime)
    }
    
    /// slider拖动结束
    @IBAction private func progressSliderTouchUpAction(_ slider: UISlider)
    {
        // 恢复定时器
        startTimer()
        
        if !audioController.isPlaying() {
            // 音频处于暂停状态的快进快退 (音频先播放然后再快进或者快退到拖到的位置) 如果暂停状态快进快退 不进行先播放那么拖动结束后的播放状态还是暂停时候的状态
            audioController.pause()
        }
        
        var pos = FSStreamPosition()
        pos.position = slider.value
        // 跳转进度
        audioController.activeStream.seek(to: pos)
    }
    
    /// 关闭当前控制器
    @IBAction private func closeAction(_ sender: UIButton)
    {
        // 停止播放音乐
        audioController.stop()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 私有属性
    /// 帖子视图模型
    private var topicViewModel:TCJTopicViewModel
    /// 图片
    private var imageView = UIImageView()
    /// 音频播放器
    private lazy var audioController:FSAudioController = { [weak self] in
        let urlString = self?.topicViewModel.voiceURL
        let voiceURL = URL(string: urlString!)
        let audioController = FSAudioController(url: voiceURL!)
        return audioController!
        }()
    
    /// 暂停播放按钮
    @IBOutlet private weak var playOrPauseButton: UIButton!
    /// 播放进度
    @IBOutlet private weak var progressSlider:UISlider!
    /// 当前时长
    @IBOutlet private weak var currentTimeLabel: UILabel!
    /// 总时长
    @IBOutlet private weak var totalTimeLabel: UILabel!
    /// 定时器
    private var timer:Timer?
    

}

// MARK: - 音频播放相关

private extension TCJVoicePlayerViewController
{
    /// 开始定时器
    func startTimer() -> Void
    {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(updatePlaybackProgress), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    /// 结束定时器
    func stopTimer() -> Void
    {
        timer?.invalidate()
        timer = nil
    }
    
    /// 更新音频播放进度
    @objc private func updatePlaybackProgress() -> Void
    {
        playOrPauseButton.isSelected = !audioController.isPlaying()
        
        if audioController.isPlaying() {
            // 音频总时长
            let duration = audioController.activeStream.duration
            let totalTime = duration.minute * 60 + duration.second
            // 已经加载播放时长
            let current = audioController.activeStream.currentTimePlayed
            let currentTime = current.minute * 60 + current.second
            // 更新进度
            progressSlider.value = Float(currentTime) / Float(totalTime)
            currentTimeLabel.text = secondsToString(seconds: currentTime)
            totalTimeLabel.text = secondsToString(seconds: totalTime)
        }
    }
    
    /// 播放时长转换为字符串
    ///
    /// - Parameter seconds: 播放时长
    /// - Returns: String
    func secondsToString(seconds:UInt32) -> String
    {
        let minute = seconds / 60
        let second = seconds % 60
        return String(format: "%02d:%02d", minute,second)
    }
}

// MARK: - 其他方法

extension TCJVoicePlayerViewController
{
    /// 支持方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        // 状态栏设置 自定义转场动画后 控制器无法再管理状态栏 需要设置这个属性
        modalPresentationCapturesStatusBarAppearance = true
        
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
        view.insertSubview(imageView, at: 1)
    }
    
    // 注册通知
    private func registerNotification() -> Void
    {
        // 监听音频流播放状态发生变化
        NotificationCenter.default.addObserver(self, selector: #selector(audioStreamStateChangeNotification(notification:)), name: NSNotification.Name.FSAudioStreamStateChange, object: nil)
    }
    
    /// 设置图片
    private func setImageView() -> Void
    {
        guard let imageURL = topicViewModel.imageURL else {
            return
        }
        
        // 设置高清大图
        if let image =  SDWebImageManager.shared().imageCache?.imageFromCache(forKey: imageURL) {
            // 有大图 设置大图
            setBigImage(image: image)
        } else {
            // 没有大图 进行下载
            SDWebImageManager.shared().loadImage(with: URL(string: imageURL), options: [.retryFailed,.refreshCached], progress: nil) { [weak self] (image, _, error, _, _, _) in
                if error != nil || image == nil {
                    TCJPrint("大图下载失败")
                    return
                }
                
                // 设置大图
                self?.setBigImage(image: image!)
            }
        }
    }
    
    /// 设置大图
    private func setBigImage(image:UIImage) -> Void
    {
        imageView.image = image
        // 等比例缩放图片
        let width = view.width
        let height = ceil(width / image.size.width * image.size.height)
        
        imageView.frame = CGRect(x: (view.width - width) / 2, y: (view.height - height) / 2, width: width, height: height)
    }
}

