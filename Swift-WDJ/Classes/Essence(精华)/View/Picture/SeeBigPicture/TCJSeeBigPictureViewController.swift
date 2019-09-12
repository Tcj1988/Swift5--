//
//  TCJSeeBigPictureViewController.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import SDWebImage
import Photos
import SVProgressHUD

class TCJSeeBigPictureViewController: UIViewController {

    // MARK: - 构造方法
    
    init(topicViewModel:TCJTopicViewModel?)
    {
        super.init(nibName: nil, bundle: nil)
        
        self.topicViewModel = topicViewModel
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
        super.loadView()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        setImage()
    }
    
    // MARK: - 事件监听
    
    @objc private func tapImageViewAction() -> Void
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveImageToPhotoLibrary() -> Void
    {
        guard let appName = Bundle.main.appName else {
            return
        }
        
        // 检查图片是否已经下载完成
        if SDWebImageManager.shared().imageCache?.diskImageDataExists(withKey: topicViewModel?.imageURL) == false {
            return
        }
        
        guard let filePath = SDWebImageManager.shared().imageCache?.defaultCachePath(forKey: topicViewModel?.imageURL) else {
            return
        }
        
        let fileURL = URL(fileURLWithPath: filePath)
        PHPhotoLibrary.saveImage(imageFielURL: fileURL,collectionName: appName) { (error) in
            if error != nil {
                SVProgressHUD.showSuccess(withStatus: "保存失败")
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "保存成功")
        }
    }
    
    // MARK: - 私有属性 && 懒加载
    
    /// 数据模型
    private var topicViewModel:TCJTopicViewModel?
    
    /// 大图
    private lazy var bigImageView:FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    /// scrollView
    private lazy var scrollView:UIScrollView = UIScrollView()
    /// 保存按钮
    private lazy var saveButton:UIButton = UIButton(title: "保存", normalColor: UIColor.white, highlightedColor: UIColor.white, fontSize: 15, backgroundColor: UIColor.darkGray, target: self, action: #selector(saveImageToPhotoLibrary))
    

}

// MARK: - UIScrollViewDelegate

extension TCJSeeBigPictureViewController:UIScrollViewDelegate
{
    // 缩放哪个视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return bigImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        var scale = (bigImageView.transform.a - scrollView.minimumZoomScale) / scrollView.minimumZoomScale
        
        // 小于最小缩放比例一半 继续 缩小就退出当前控制器
        if scale < scrollView.minimumZoomScale / 2 {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // 处理负数和超过1
        scale = scale < 0 ? 0 : scale
        scale = scale > 1 ? 1 : scale
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(scale)
        // 当前比例 >= 原始尺寸 背景黑色 缩小则是透明色
        view.backgroundColor = scale >= 1 ? UIColor.black : UIColor.clear
        // 缩小时隐藏保存按钮
        saveButton.isHidden = scale < 1
    }
    
    // 停止缩放
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        // 更新内容边距 要获取缩放视图的大小要使用frame,缩放时frame改变 bounds不改变 缩放时会自动设置contentSize
        var verMargin = (scrollView.height - view!.frame.height) / 2
        verMargin = verMargin < 0 ? 0 : verMargin
        var horMargin = (scrollView.width - view!.frame.width) / 2
        horMargin = horMargin < 0 ? 0 : horMargin
        
        scrollView.contentInset = UIEdgeInsets(top: verMargin, left: horMargin, bottom: verMargin, right: horMargin)
    }
}


// MARK: - 其他方法

extension TCJSeeBigPictureViewController
{
    /// 支持方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    /// 状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 设置图片
    private func setImage() -> Void
    {
        guard let imageURL = topicViewModel?.imageURL else {
            return
        }
        
        // 设置高清大图
        if let bigImageData = SDWebImageManager.shared().imageCache?.diskImageData(forKey: imageURL){
            // 有大图 设置大图
            setBigImage(imageData: bigImageData)
        } else {
            // 没有大图 进行下载
            SDWebImageManager.shared().loadImage(with: URL(string: imageURL), options: [.retryFailed,.refreshCached], progress: nil) { [weak self] (_, imageData, error, _, _, _) in
                if error != nil || imageData == nil {
                    TCJPrint("大图下载失败")
                    return
                }
                
                // 设置大图
                self?.setBigImage(imageData: imageData!)
            }
        }
    }
    
    /// 设置大图
    private func setBigImage(imageData:Data) -> Void
    {
        if topicViewModel?.isGIF == true {
            // gif图片
            bigImageView.animatedImage = FLAnimatedImage(animatedGIFData: imageData)
        } else {
            // 普通图片
            bigImageView.image = UIImage(data: imageData)
        }
        
        // 等比例缩放图片
        let width = scrollView.width
        let height = width / bigImageView.image!.size.width * bigImageView.image!.size.height
        bigImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        // 设置内容边距
        let margin = (scrollView.height - height) / 2
        let topMargin = margin < 0 ? (isIPhoneX ? kStatusBarHeight : 0) : margin
        let bottomMargin = margin < 0 ? 0 : margin
        scrollView.contentInset = UIEdgeInsets(top: topMargin, left: 0, bottom: bottomMargin, right: 0)
        
        // 设置滚动范围
        scrollView.contentSize = CGSize(width: 0, height: height)
    }
    
    /// 设置界面
    private func setUpUI() -> Void
    {
        modalPresentationCapturesStatusBarAppearance = true
        
        view.backgroundColor = UIColor.black
        scrollView.backgroundColor = UIColor.black
        
        // 添加子控件
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        
        // 布局
        scrollView.frame = view.bounds
        let buttonSize = CGSize(width: 70, height: 36)
        saveButton.frame = CGRect(x: view.width - buttonSize.width - 30, y: view.height - buttonSize.height - 30, width: buttonSize.width, height: buttonSize.height)
        // 设置scrollView
        setUpScrollView()
    }
    
    /// 设置scrollView
    private func setUpScrollView() -> Void
    {
        // 设置scrollView
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        // 设置缩放
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        // 设置代理
        scrollView.delegate = self
        
        // 添加imageView
        bigImageView.isUserInteractionEnabled = true
        bigImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImageViewAction)))
        scrollView.addSubview(bigImageView)
    }
}
