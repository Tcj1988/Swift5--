//
//  TCJNavigationController.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/11.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJNavigationController: UINavigationController {

    // MARK:- 控制器生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addPanGestureRecognizer()
        navigationBar.tintColor = UIColor.darkGray
    }
    
    // MARK: - 重写父类方法
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 如果不是根控制器 跳转时隐藏底部tabbar
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    // MARK: - 内部私有方法
    
    /// 添加滑动退出页面手势
    private func addPanGestureRecognizer() -> Void
    {
        /*
         <UIScreenEdgePanGestureRecognizer: 0x7fd53340f760; state = Possible delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fd533707a30>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fd533604b80>)>>
         _targets
         */
        
        guard let value = interactivePopGestureRecognizer?.value(forKey:
            "targets") as? NSArray,
            let recognizerTarget = value.firstObject as? NSObject,
            let target = recognizerTarget.value(forKey: "target")
            else {
                return
        }
        
        // 添加滑动手势
        let pan = UIPanGestureRecognizer(target: target, action:Selector(("handleNavigationTransition:")))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        // 禁用系统手势
        interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: - UIGestureRecognizerDelegate

extension TCJNavigationController:UIGestureRecognizerDelegate
{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return viewControllers.count > 1
    }
}
