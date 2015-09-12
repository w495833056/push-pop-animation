//
//  GDetailViewController.swift
//  magicTransition
//
//  Created by golven on 15/9/11.
//  Copyright © 2015年 magicEngineer. All rights reserved.
//

import UIKit

class GDetailViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    //--------1--------
    //要实现那种根据手势滑动多少来决定过度动画的进度效果
    //就需要UIPercentDrivenInteractiveTransition的实例来驱动
    //但是我们实例化之后怎样去使用这个对象呢？
    //很简单，在代理方法中返回这个对象就行了
    var percentDriven: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self;
        
        
        let edge = UIScreenEdgePanGestureRecognizer(target: self, action: "edge:")
        edge.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(edge)
    }
    
    func edge(edge: UIScreenEdgePanGestureRecognizer) {
        let progress = edge.locationInView(self.view).x/self.view.frame.size.width
        if edge.state == UIGestureRecognizerState.Began {
            //刚刚开始，所以实例化一个驱动对象
            percentDriven = UIPercentDrivenInteractiveTransition()
            //告诉导航栏开始动画
            //但是这个动画由我们自己的驱动对象去驱动
            //因此这时候在下面的1中返回我们自己的驱动对象
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else if (edge.state == UIGestureRecognizerState.Changed) {
            //设置驱动的进程,自己滑一滑就明白了
            //根据手势滑动的距离相对于屏幕宽度的百分比
            percentDriven?.updateInteractiveTransition(progress)
        } else if (edge.state == UIGestureRecognizerState.Ended) {
            if progress >= 0.5 {
                //完全pop
                percentDriven?.finishInteractiveTransition()
            } else {
                //取消
                percentDriven?.cancelInteractiveTransition()
            }
            //释放它，如果不释放，你自己试试滑动不到一半的时候取消
            //看看是什么效果
            percentDriven = nil
        }
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Pop {
            return GPopTransition()
        } else {
            return nil
        }
    }
    
    //--------1--------
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is GPopTransition {
            return percentDriven
        } else {
            return nil
        }
    }
    
}
