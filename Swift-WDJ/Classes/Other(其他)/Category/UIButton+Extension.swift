//
//  UIButton+Extension.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

extension UIButton
{
    /// 便利构造方法
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - normalColor: 标题默认颜色 默认darkGray
    ///   - highlightedColor: 标题高亮颜色 默认orange
    ///   - fontSize: 标题字体大小
    ///   - backgroundImageName: 背景图片名称
    ///   - backgroundColor: 背景颜色
    ///   - imageName: 图片名称
    ///   - target: 监听对象
    ///   - action: 监听方法
    convenience init(title:String? = nil,normalColor:UIColor? = UIColor.darkGray,highlightedColor:UIColor? = UIColor.orange,fontSize:CGFloat = 15,backgroundImageName:String? = nil,backgroundColor:UIColor? = nil,imageName:String? = nil,target:AnyObject?,action:Selector?)
    {
        self.init()
        
        if title != nil {
            setTitle(title, for: .normal)
            setTitleColor(normalColor, for: .normal)
            setTitleColor(highlightedColor, for: .highlighted)
            titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            self.backgroundColor = backgroundColor
        }
        
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
            setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        }
        
        if let backgroundImageName = backgroundImageName {
            setBackgroundImage(UIImage.stretchableImage(imageName: backgroundImageName), for: .normal)
            setBackgroundImage(UIImage.stretchableImage(imageName: (backgroundImageName + "_highlighted")), for: .highlighted)
        }
        
        if let target = target,
            let action = action {
            addTarget(target, action: action, for: .touchUpInside)
        }
        
        sizeToFit()
    }
}

public enum kButtonEdgeInsetsStyle:Int
{
    /// image在上，label在下
    case top = 0
    /// image在左，label在右
    case left = 1
    /// image在下，label在上
    case bottom = 2
    /// image在右，label在左
    case right = 3
}

extension UIButton
{
    
    /// 设置button的titleLabel和imageView的布局样式，及间距
    ///
    /// - Parameters:
    ///   - style: titleLabel和imageView的布局样式
    ///   - space: titleLabel和imageView的间距
    open func layoutButtonWithEdgeInsetsStyle(style:kButtonEdgeInsetsStyle,space:CGFloat) -> Void
    {
        
        guard let imageView = imageView,
            let titleLabel = titleLabel else {
                return
        }
        /**
         *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
         *  如果只有title，那它上下左右都是相对于button的，image也是一样；
         *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
         */
        
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith = imageView.image?.size.width ?? 0
        let imageHeight = imageView.image?.size.height ?? 0
        let labelWidth = titleLabel.intrinsicContentSize.width
        let labelHeight = titleLabel.intrinsicContentSize.height
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top:-labelHeight-space/2.0, left:0, bottom:0, right:-labelWidth)
            labelEdgeInsets = UIEdgeInsets(top:0, left:-imageWith, bottom:-imageHeight-space/2.0, right:0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top:0, left:-space/2.0, bottom:0, right:space/2.0)
            labelEdgeInsets = UIEdgeInsets(top:0, left:space/2.0, bottom:0, right:-space/2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top:0, left:0, bottom:-labelHeight-space/2.0, right:-labelWidth)
            labelEdgeInsets = UIEdgeInsets(top:-imageHeight-space/2.0, left:-imageWith, bottom:0, right:0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top:0, left:labelWidth+space/2.0, bottom:0, right:-labelWidth-space/2.0)
            labelEdgeInsets = UIEdgeInsets(top:0, left:-imageWith-space/2.0, bottom:0, right:imageWith+space/2.0)
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

