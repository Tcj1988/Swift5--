//
//  TCJImageCacheManager.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import SDWebImage

class TCJImageCacheManager: NSObject {
    /// 创建单例
    public static var shared:TCJImageCacheManager = TCJImageCacheManager()
    /// 图片缓存
    private lazy var imageCache = { () -> NSCache<NSString, UIImage> in
        let imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100 // 最多缓存数
        imageCache.totalCostLimit = 10 * 1024 * 1024 // 缓存总成本 单位是字节
        return imageCache
    }()
    
    // MARK:- 构造方法
    private override init() {
        super.init()
        // 注册内存警告通知
        NotificationCenter.default.addObserver(self, selector: #selector(removeCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        // 移除通知
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- 图片缓存
extension TCJImageCacheManager
{
    /// 根据图片url返回渲染后的图片
    ///
    /// - Parameters:
    ///   - key: 图片url
    ///   - size: 图片尺寸
    ///   - backgroundColor: 背景色 默认白色
    ///   - isUserIcon: 是否是用户头像(进行圆角处理) 默认false
    ///   - isLongPicture: 是否是长图(进行裁剪处理) 默认false
    ///   - completion: 完成回调
    open func imageForKey(key:String?, size:CGSize, backgroundColor:UIColor = UIColor.white, isUserIcon:Bool = false, isLongPicture:Bool = false, completion:@escaping(UIImage?) -> Void) -> Void{
        guard let key = key as NSString? else {
            completion(nil)
            return
        }
        
        // 如果已经缓存了,直接返回
        if imageCache.object(forKey: key) != nil {
            completion(imageCache.object(forKey: key))
            return
        }
        
        // 如果本地有缓存,进行处理
        if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: key as String) {
            setUpImageToCache(key: key, image: image, size: size, backgroundColor: backgroundColor, isUserIcon: isUserIcon, isLongPicture: isLongPicture, completion: completion)
            return
        }
        
        // 内存缓存 磁盘缓存图片都不存在 进行下载
        SDWebImageManager.shared().loadImage(with: URL(string: key as String), options: [.retryFailed,.refreshCached], progress: nil) { (image, _, error, _, _, _) in
            if image == nil || error != nil {
                completion(nil)
                return
            }
            
            self.setUpImageToCache(key: key, image: image!, size: size, backgroundColor: backgroundColor, isUserIcon: isUserIcon, isLongPicture: isLongPicture, completion: completion)
        }
    }
    
    /// 清除缓存
    @objc private func removeCache() -> Void{
        imageCache.removeAllObjects()
    }
    
    /// 裁剪图片
    ///
    /// - Parameters:
    ///   - sourceImage: 原始图片
    ///   - imageSize: 目标尺寸
    ///   - backgroundColor: 背景颜色
    /// - Returns: UIImage
    private func clipImage(sourceImage:UIImage, imageSize:CGSize,backgroundColor:UIColor = UIColor.white) -> UIImage?
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0) // 不透明的上下文
        let rect = CGRect(origin: CGPoint.zero, size: imageSize)
        
        // 2.绘制背景颜色
        backgroundColor.setFill()
        UIBezierPath(rect: rect).fill()
        
        // 4.绘制图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.width / sourceImage.size.width * sourceImage.size.height))
        
        // 5.取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 6.关闭上下文
        UIGraphicsEndImageContext()
        
        // 7.返回图片
        return newImage
    }
    
    /// 设置图片到缓存
    ///
    /// - Parameters:
    ///   - key: 图片缓存的键
    ///   - image: 图片
    ///   - size: 尺寸
    ///   - backgroundColor: 背景颜色
    ///   - isUserIcon: 是否是用户头像
    ///   - isLongPicture: 是否长图
    ///   - completion: 完成回调
    private func setUpImageToCache(key:NSString,image:UIImage,size:CGSize,backgroundColor:UIColor,isUserIcon:Bool = false,isLongPicture:Bool = false,completion:@escaping (UIImage?) -> Void) -> Void
    {
        DispatchQueue.global().async {
            // 进行图片处理
            var newImage:UIImage?
            if isUserIcon {
                newImage = image.circleIconImage(imageSize: size, backgroundColor: backgroundColor)
            } else if isLongPicture {
                newImage = self.clipImage(sourceImage: image, imageSize: size, backgroundColor: backgroundColor)
            } else {
                newImage = image.scaleToSize(imageSize: size, backgroundColor: backgroundColor)
            }
            
            DispatchQueue.main.sync {
                // 保存到内存中
                self.imageCache.setObject(newImage!, forKey: key)
                
                // 完成回调
                completion(newImage)
            }
        }
    }
}
