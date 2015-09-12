//
//  GPushTransition.swift
//  magicTransition
//
//  Created by golven on 15/9/11.
//  Copyright © 2015年 magicEngineer. All rights reserved.
//

import UIKit

class GPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        //根据transition找到我们的前一个视图和将要push进去的那个视图
        //我自己理解，container是整个push或者pop动画进行的一个场所
        //我们的动画就是在这个container中完成的
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! ViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! GDetailViewController
        let container = transitionContext.containerView()
        
        //截图，true表示保留被截的范围内之前修改过的内容
        //false表示就截图当前显示的这个样子
        let shotImageView = fromVC.selectedCell!.imageView.snapshotViewAfterScreenUpdates(false)
        //把fromVC.selectedCell!.imageView的frame转换到container上来！
        //也就frame是一样的，但是frame对应的父视图不一样
        shotImageView.frame = container!.convertRect(fromVC.selectedCell!.imageView.frame, fromView: fromVC.selectedCell)
        fromVC.selectedCell!.imageView.hidden = true
        //我的理解就是取动画结束之后toVC的frame，然后设置给toVC的view
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        
        //注意层级关系
        container?.addSubview(toVC.view)
        container?.addSubview(shotImageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            //开始动画
            shotImageView.frame = toVC.imageView.frame
            shotImageView.center = CGPointMake(toVC.view.center.x, shotImageView.center.y)
            toVC.view.alpha = 1
            }) { (mybool) -> Void in
                //结束动画
                fromVC.selectedCell?.imageView.hidden = false
                toVC.imageView.image = fromVC.selectedCell?.imageView.image
                shotImageView.removeFromSuperview()
                //我们自己的动画完成，把navigation交还给系统管理
                transitionContext.completeTransition(true)
        }
    }
    
}
