//
//  PHPhotoLibrary+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import Photos

extension PHPhotoLibrary
{
    /// 保存图片至相册
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - imageFielURL: 图片路径
    ///   - videoFileURL: 视频路径
    ///   - collectionName: 相册名称
    ///   - completion: 完成回调
    open class func saveImage(image:UIImage? = nil,imageFielURL:URL? = nil,videoFileURL:URL? = nil,collectionName:String,completion:@escaping (NSError?) -> Void) -> Void
    {
        let status = PHPhotoLibrary.authorizationStatus() // 获取状态码
        if (status == PHAuthorizationStatus.notDetermined) {
            // 请求授权
            PHPhotoLibrary.requestAuthorization { (status) in
                if (status == PHAuthorizationStatus.authorized) {
                    // 同意授权 保存图片
                    self.saveImage(image: image, imageFielURL: imageFielURL, videoFileURL: videoFileURL, toCollectionName: collectionName, completion: completion)
                } else {
                    //  拒绝授权
                    let error = NSError(domain: "error", code: 100000004, userInfo: ["reason":"请在设置界面, 授权应用访问相册"])
                    completion(error)
                }
            }
        } else if status == PHAuthorizationStatus.authorized {
            self.saveImage(image: image, imageFielURL: imageFielURL, videoFileURL: videoFileURL, toCollectionName: collectionName, completion: completion)
        } else {
            let error = NSError(domain: "error", code: 100000004, userInfo: ["reason":"请在设置界面, 授权应用访问相册"])
            completion(error)
        }
    }
}

// MARK: - 私有方法

private extension PHPhotoLibrary
{
    // 保存图片至相册
    private class func saveImage(image:UIImage? = nil,imageFielURL:URL? = nil,videoFileURL:URL? = nil,toCollectionName:String,completion:@escaping (NSError?) -> Void) -> Void
    {
        /*
         PHAsset 代表相册中的一个相片
         PHAssetCollection 代表照片应用中的一个相册
         
         PHAsset fetch... 取相片
         PHAssetCollection fetch... 取相册
         
         PHAsset  增删改 PHAssetChangeRequest
         PHAssetCollection 增删改 PHAssetCollectionChangeRequest
         */
        
        try? PHPhotoLibrary.shared().performChangesAndWait {
            // 1.获取相册
            let assetCollection = getAssetCollectionWithName(name: toCollectionName)
            
            // 2.判断相册是否存在 如果存在则向相册存放图片 如果不存在先创建相册
            var assetCollectionChangeRequest:PHAssetCollectionChangeRequest?
            if (assetCollection == nil) {
                assetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: toCollectionName)
            } else {
                assetCollectionChangeRequest = PHAssetCollectionChangeRequest (for: assetCollection!)
            }
            
            // 3.创建相片修改对象
            var assetChangeRequest:PHAssetChangeRequest?
            if (image != nil) {
                assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image!)
            } else if (imageFielURL != nil) {
                assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageFielURL!)
            } else if (videoFileURL != nil) {
                assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoFileURL!)
            }
            
            // 4.保存相片
            let array = NSArray(arrayLiteral: assetChangeRequest!.placeholderForCreatedAsset!)
            assetCollectionChangeRequest?.addAssets(array)
            completion(nil)
        }
    }
    
    /// 根据相册名称返回对象的相册
    ///
    /// - Parameter name: 相册名称
    /// - Returns: PHAssetCollection
    private class func getAssetCollectionWithName(name:String) -> PHAssetCollection?
    {
        // 1.取出所有的相册
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        // 2.遍历 查找指定名称的相册
        var destinationCollection:PHAssetCollection?
        result.enumerateObjects { (collection, index, isStop) in
            if collection.localizedTitle == name {
                destinationCollection = collection
                isStop.pointee = true
            }
        }
        
        return destinationCollection
    }
}


