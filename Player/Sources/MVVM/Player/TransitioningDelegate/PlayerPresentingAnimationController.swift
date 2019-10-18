//
//  PlayerPresentingAnimationController.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let miniPlayerController: MiniPlayerViewController
    
    init(miniPlayerController: MiniPlayerViewController) {
        self.miniPlayerController = miniPlayerController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedViewController = transitionContext.viewController(forKey: .to), let presentingViewController = transitionContext.viewController(forKey: .from) else { return }
        
        miniPlayerController.coverImageView.isHidden = true
        guard let miniPlayerSnapshotView = miniPlayerController.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let coverImageView = UIImageView(image: miniPlayerController.coverImage)
        coverImageView.contentMode = .scaleAspectFit
        let containerView = transitionContext.containerView
        
        containerView.addSubview(presentedViewController.view)
        containerView.addSubview(miniPlayerSnapshotView)
        containerView.addSubview(coverImageView)
    
        let finalFrameForPresentedView = transitionContext.finalFrame(for: presentedViewController)
        presentedViewController.view.frame = finalFrameForPresentedView
        presentedViewController.view.frame.origin.y = containerView.bounds.height - miniPlayerController.view.bounds.height - presentingViewController.view.safeAreaInsets.bottom
        miniPlayerSnapshotView.frame = miniPlayerController.view.frame
        coverImageView.frame = miniPlayerController.coverImageView.convert(coverImageView.bounds, to: presentingViewController.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                miniPlayerSnapshotView.alpha = 0.0
                presentedViewController.view.frame = finalFrameForPresentedView
                coverImageView.frame.origin = presentedViewController.view.center
                miniPlayerSnapshotView.frame.origin = finalFrameForPresentedView.origin
        }, completion: { [weak self] finished in
            miniPlayerSnapshotView.removeFromSuperview()
            self?.miniPlayerController.coverImageView.isHidden = false
            transitionContext.completeTransition(finished)
        })
    }
}

