//
//  PlayerDismissingAnimationController.swift
//  Player
//
//  Created by Zakhar Azatyan on 01.11.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerDismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let finalFrameForPresentedView = transitionContext.finalFrame(for: presentedViewController)
        
        let containerView = transitionContext.containerView
        let offscreenFrame = CGRect(x: 0, y: containerView.bounds.height, width: finalFrameForPresentedView.width, height: finalFrameForPresentedView.height)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseIn,
            animations: {
                presentedViewController.view.frame = offscreenFrame
        }) { finished in
                transitionContext.completeTransition(finished)
        }
    }
}

