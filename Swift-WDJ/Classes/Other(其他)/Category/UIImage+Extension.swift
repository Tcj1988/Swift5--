//
//  UIImage+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/10.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
extension UIImage
{
    open func stretchableImage() -> UIImage
    {
        return stretchableImage(withLeftCapWidth: Int(size.width * 0.5), topCapHeight: Int(size.height * 0.5))
    }
    
    /// 创建一张不拉伸图片
    ///
    /// - Parameter imageName: 图片名称
    /// - Returns:UIImage
    open class func stretchableImage(imageName:String) -> UIImage?
    {
        return UIImage(named: imageName)?.stretchableImage()
    }
    
    
    /// 返回一张不渲染的图片
    ///
    /// - Parameter imageName: 图片名称
    /// - Returns: UIImage
    open class func originalImage(imageName:String) -> UIImage?
    {
        return UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
    }
    
    /// 创建圆形图像
    ///
    /// - Parameters:
    ///   - imageSize: 图像大小
    ///   - backgroundColor: 背景色
    /// - Returns: UIImage?
    open func circleIconImage(imageSize:CGSize,backgroundColor:UIColor = UIColor.white) -> UIImage?
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0) // 不透明的上下文
        let rect = CGRect(origin: CGPoint.zero, size: imageSize)
        
        // 2.绘制背景颜色
        backgroundColor.setFill()
        UIBezierPath(rect: rect).fill()
        
        // 3.绘制圆形裁剪区域
        let center = CGPoint(x: imageSize.width * 0.5, y: imageSize.height * 0.5)
        let path = UIBezierPath(arcCenter: center, radius: fmin(center.x, center.y), startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
        path.addClip()
        
        // 4.绘制图片
        draw(in: rect)
        
        // 绘制圆形
        UIColor.lightGray.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        // 5.取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 6.关闭上下文
        UIGraphicsEndImageContext()
        
        // 7.返回图片
        return newImage
    }
    
    /// 返回圆形头像
    ///
    /// - Parameters:
    ///   - imageName: 图像名称
    ///   - imageSize: 图像大小
    ///   - backgroundColor: 背景色
    /// - Returns: UIImage?
    open class func circleIconImage(imageName:String,imageSize:CGSize,backgroundColor:UIColor = UIColor.white) -> UIImage?
    {
        return UIImage(named: imageName)?.circleIconImage(imageSize: imageSize, backgroundColor: backgroundColor)
    }
    
    
    /// 缩放图像至指定大小
    ///
    /// - Parameters:
    ///   - imageSize: 图像大小
    ///   - backgroundColor: 背景色 默认白色
    /// - Returns: UIImage?
    open func scaleToSize(imageSize:CGSize,backgroundColor:UIColor = UIColor.white) -> UIImage?
    {
        // 1.开启图片上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, true, 0) // 不透明的上下文
        let rect = CGRect(origin: CGPoint.zero, size: imageSize)
        
        // 2.绘制背景颜色
        backgroundColor.setFill()
        UIBezierPath(rect: rect).fill()
        
        // 3.绘制矩形裁剪区域
        let path = UIBezierPath(rect: rect)
        path.addClip()
        
        // 4.绘制图片
        draw(in: rect)
        
        // 5.取出图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 6.关闭上下文
        UIGraphicsEndImageContext()
        
        // 7.返回图片
        return newImage
    }
}
