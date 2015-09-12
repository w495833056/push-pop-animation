//
//  GPopTransition.swift
//  magicTransition
//
//  Created by golven on 15/9/11.
//  Copyright © 2015年 magicEngineer. All rights reserved.
//

import UIKit

class GPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! GDetailViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! ViewController
        let container = transitionContext.containerView()
        
        let snapShotView = fromVC.imageView.snapshotViewAfterScreenUpdates(false)
        snapShotView.frame = container!.convertRect(fromVC.imageView.frame, fromView: fromVC.view)
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        
        fromVC.imageView.hidden = true
        toVC.selectedCell!.imageView.hidden = true
        
        container!.insertSubview(toVC.view, belowSubview: fromVC.view)
        container!.addSubview(snapShotView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            fromVC.view.alpha = 0
            //坐标要自己想清楚，脑子里面要有那个动画的过程
            snapShotView.frame = container!.convertRect(toVC.selectedCell!.imageView.frame, fromView: toVC.selectedCell)
            }) { (mybool) -> Void in
                toVC.selectedCell!.imageView.hidden = false
                snapShotView.removeFromSuperview()
                //这里需要设置一下
                //因为手势pop的时候如果这里不设置为false，则返回取消之后也会被隐藏掉
                fromVC.imageView.hidden = false
                //这里如果不需要用手势滑动返回的话，直接用true就行
                //因为有可能滑动返回的时候只滑动一点点，这时候应该就不能pop出去，所以transition就cancel了
                //那么这里就应该是false，表示还没有结束
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}
