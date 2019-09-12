//
//  TCJTabBarVC.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJTabBarVC: UITabBarController {

    // MARK:- 构造方法
    
    /// 发布按钮
    private lazy var composeButton = UIButton(imageName: "tabBar_publish_icon", target: self, action: #selector(composeButtonAction))
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpTabBarItem()
        addAllChildViewControllers()
        addComposeButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 控制器生命周期方法
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 发布按钮
        tabBar.bringSubviewToFront(composeButton)
    }
    
    // MARK: - 事件监听
    @objc private func composeButtonAction() -> Void
    {
        TCJPrint("别摸我")
    }

    // MARK: - 支持方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask
        {
        return .portrait
    }
}

// MARK: - 添加子控制器

private extension TCJTabBarVC
{
    /// 添加子控制器
    func addAllChildViewControllers() -> Void {
        addChildViewController(viewControllerClass: TCJEssenceVC.self, title: "精华", imageName: "tabBar_essence_icon", selectedImageName: "tabBar_essence_click_icon")
        addChildViewController(viewControllerClass: TCJNewTopicVC.self, title: "新帖", imageName: "tabBar_new_icon", selectedImageName: "tabBar_new_click_icon")
        addChild(UIViewController())
        addChildViewController(viewControllerClass: TCJFocusVC.self, title: "关注", imageName: "tabBar_friendTrends_icon", selectedImageName: "tabBar_friendTrends_click_icon")
        addChildViewController(viewControllerClass: TCJMineTableVC.self, title: "我的", imageName: "tabBar_me_icon", selectedImageName: "tabBar_me_click_icon")
    }
    
    /// 添加子控制器
    ///
    /// - Parameters:
    ///   - viewControllerClass: 控制器类型
    ///   - title: 标题
    ///   - imageName: 图片名称
    ///   - selectedImageName: 选中状态图片名称
    func addChildViewController(viewControllerClass:UIViewController.Type,title:String,imageName:String,selectedImageName:String) -> Void {
        let viewController = viewControllerClass.init()
        viewController.navigationItem.title = title
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: imageName)
        viewController.tabBarItem.selectedImage = UIImage.originalImage(imageName: selectedImageName)
        let nav = TCJNavigationController(rootViewController: viewController)
        addChild(nav)
    }
    
    /// 设置tabBarItem
    func setUpTabBarItem() -> Void {
        let item = UITabBarItem.appearance(whenContainedInInstancesOf: [TCJTabBarVC.self])
        item.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.lightGray], for: .normal)
        item.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.darkGray], for: .selected)
    }
    
    func addComposeButton() -> Void {
        // 宽度减1 这样缩进时发布按钮就会大一点 防止容错点 点击后进入中间的占位控制器
        let width = (tabBar.width / CGFloat(viewControllers?.count ?? 1)) - 1
        tabBar.addSubview(composeButton)
        composeButton.frame = tabBar.bounds.insetBy(dx: width * 2, dy: 0)
    }
}
