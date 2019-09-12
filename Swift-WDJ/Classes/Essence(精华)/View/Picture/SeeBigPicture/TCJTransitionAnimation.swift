//
//  TCJTransitionAnimation.swift
//  Swift-WDJ
//
//  Created by tangchangjiang on 2019/9/12.
//  Copyright © 2019 tangchangjiang. All rights reserved.
//

import UIKit

class TCJTransitionAnimation: NSObject,UIViewControllerTransitioningDelegate {
    /// 是否是presented
    private var isPresented:Bool = false
    
    // presented动画代理
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresented = true
        return self
    }
    
    // dismiss动画代理
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresented = false
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension TCJTransitionAnimation:UIViewControllerAnimatedTransitioning
{
    // 动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        isPresented ? presentedAnimation(transitionContext: transitionContext) : dismissAnimation(transitionContext: transitionContext)
    }
    
    private func presentedAnimation(transitionContext:UIViewControllerContextTransitioning?) -> Void
    {
        guard let toView = transitionContext?.view(forKey: UITransitionContextViewKey.to),
            let containerView = transitionContext?.containerView else {
                return
        }
        
        containerView.addSubview(toView)
        toView.frame = UIScreen.main.bounds
        containerView.alpha = 0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            containerView.alpha = 1
        }) { (_) in
            // 一定要调用完成回调 否则无法正确进行modal控制器
            transitionContext?.completeTransition(true)
        }
    }
    
    private func dismissAnimation(transitionContext:UIViewControllerContextTransitioning?) -> Void
    {
        guard let fromView = transitionContext?.view(forKey: UITransitionContextViewKey.from),
            let containerView = transitionContext?.containerView else {
                return
        }
        
        containerView.alpha = 1
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            containerView.alpha = 0
        }) { (_) in
            fromView.removeFromSuperview()
            // 一定要调用完成回调 否则无法正确进行modal控制器
            transitionContext?.completeTransition(true)
        }
    }
}
