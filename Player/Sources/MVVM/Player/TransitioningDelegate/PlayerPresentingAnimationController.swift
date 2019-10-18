//
//  PlayerPresentingAnimationController.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let miniPlayerView: UIView
    
    init(miniPlayerView: UIView) {
        self.miniPlayerView = miniPlayerView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .to), let miniPlayerSnapshotView = miniPlayerView.snapshotView(afterScreenUpdates: false) else { return }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(presentedViewController.view)
        containerView.addSubview(miniPlayerSnapshotView)
    
        let finalFrameForPresentedView = transitionContext.finalFrame(for: presentedViewController)
        presentedViewController.view.frame = finalFrameForPresentedView
        presentedViewController.view.frame.origin.y = containerView.bounds.height
        miniPlayerSnapshotView.frame = miniPlayerView.frame
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                presentedViewController.view.frame = finalFrameForPresentedView
                miniPlayerSnapshotView.frame.origin = finalFrameForPresentedView.origin
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}

