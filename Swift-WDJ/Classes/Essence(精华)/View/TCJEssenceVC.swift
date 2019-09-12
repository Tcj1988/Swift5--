//
//  TCJEssenceVC.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit
import SnapKit

class TCJEssenceVC: UIViewController {

    // MARK: - 控制器生命周期方法
    
    override func loadView()
    {
    super.loadView()
    // 设置界面
    setUpUI()
    }
    
    override func viewDidLoad()
    {
    super.viewDidLoad()
    
    setUpNavigationItem()
    addChildViewControllers()
    titleButtonClickAction(button: titleView.subviews.first as! UIButton)
    }
    
    // MARK: - 事件监听
    
    /// 标题按钮点击
    @objc private func titleButtonClickAction(button:UIButton) -> Void
    {
    // 取消上一次选中的按钮
    let selectedButton = titleView.subviews[selectedIndex] as! UIButton
    selectedButton.isSelected = false
    // 设置当前按钮为选中状态
    button.isSelected = true
    // 记录选中索引
    selectedIndex = button.tag
    
    // scrollView滚动到对应的位置
    let offsetX = CGFloat(selectedIndex) * contentView.width
    UIView.animate(withDuration: 0.5, animations: {
    // 分割线滚动到相应的标题
    let separatorView = self.titleView.subviews.last
    separatorView?.centerX = button.centerX
    self.contentView.contentOffset = CGPoint(x: offsetX, y: 0)
    }) { (_) in
    // 添加子视图
    self.addChildView()
    }
    }
    
    // MARK: - 懒加载 && 私有属性
    
    /// 当前选中的索引
    private var selectedIndex:Int = 0
    
    /// 标题数组
    private var titleArray:[[String:Any]] = [
    ["title":"全部","classType":TCJAllTableVC.self],
    ["title":"视频","classType":TCJVideoTableVC.self],
    ["title":"声音","classType":TCJVoiceTableVC.self],
    ["title":"图片","classType":TCJPictureTableVC.self],
    ["title":"段子","classType":TCJWordTableVC.self]]
    /// 导航标题视图
    private lazy var titleView:UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    return view
    }()
    /// 内容视图
    private lazy var contentView:UIScrollView = { [weak self] in
    let scrollView = UIScrollView()
    scrollView.backgroundColor = UIColor.white
    scrollView.contentInsetAdjustmentBehavior = .never
    return scrollView
    }()
}

// MARK: - UIScrollViewDelegate

extension TCJEssenceVC:UIScrollViewDelegate
{
    // 停止减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        let index = Int(scrollView.contentOffset.x / scrollView.width)
        titleButtonClickAction(button: titleView.subviews[index] as! UIButton)
    }
}

// MARK: - 设置界面

private extension TCJEssenceVC
{
    /// 设置导航栏
    func setUpNavigationItem() -> Void
    {
        let imageView = UIImageView(image: UIImage(named: "MainTitle"))
        navigationItem.titleView = imageView
    }
    
    /// 添加子视图
    func addChildView() -> Void
    {
        // 滚动结束后 如果当前视图未添加到scrollView 则进行添加
        let view = children[selectedIndex].view!
        if !contentView.subviews.contains(view) {
            contentView.addSubview(view)
            view.frame = CGRect(x: CGFloat(selectedIndex) * contentView.width , y: 0, width: contentView.width, height: contentView.height)
        }
    }
    
    /// 设置界面
    func setUpUI() -> Void
    {
        // 添加子控件
        view.addSubview(contentView)
        view.addSubview(titleView)
        
        // 设置自动布局
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalTo(view)
            make.height.equalTo(kToolBarHeight)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 设置标题视图
        setUpTitleView()
        // 设置容器视图
        setUpContentView()
    }
    
    /// 设置标题视图
    func setUpTitleView() -> Void
    {
        // 约定前5个位按钮 最后一个分割线
        let width = view.width / CGFloat(titleArray.count)
        for (index,dictionary) in titleArray.enumerated() {
            let title = dictionary["title"] as? String
            // 添加按钮
            let button = UIButton(title:title, highlightedColor:UIColor.red,fontSize:17, target: self, action: #selector(titleButtonClickAction(button:)))
            button.tag = index
            button.setTitleColor(UIColor.red, for: .selected)
            button.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: kToolBarHeight)
            titleView.addSubview(button)
        }
        
        // 分割线视图布局
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.red
        // 分割线布局
        let separatorWidth = width * 0.7
        let separatorHeight:CGFloat = 3
        separatorView.frame = CGRect(x: (width - separatorWidth) / 2.0, y: kToolBarHeight - separatorHeight, width: separatorWidth, height: separatorHeight)
        titleView.addSubview(separatorView)
    }
    
    /// 设置容器视图
    func setUpContentView() -> Void
    {
        // 滚动范围
        contentView.contentSize = CGSize(width: CGFloat(titleArray.count) * view.width, height: 0)
        // 分页
        contentView.isPagingEnabled = true
        // 取消滚动指示器
        contentView.showsHorizontalScrollIndicator = false
        contentView.showsVerticalScrollIndicator = false
        // 代理
        contentView.delegate = self
    }
    
    /// 添加子控制器
    func addChildViewControllers() -> Void
    {
        for dictionary in titleArray {
            if let viewControllerType = dictionary["classType"] as? UIViewController.Type {
                addChild(viewControllerType.init())
            }
        }
    }
}
