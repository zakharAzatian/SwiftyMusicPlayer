//
//  PlayerPresentingAnimationController.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerPresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private weak var miniPlayerController: MiniPlayerViewController?
    
    // MARK: - Views for animation
    private let fadeView = UIView()
    private let coverImageView = UIImageView()
    
    // MARK: - Snapshots Views
    private var miniPlayerSnapshotView = UIView()
    private var tabBarSnapshotView = UIView()
    
    init(miniPlayerController: MiniPlayerViewController?) {
        self.miniPlayerController = miniPlayerController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentingController = transitionContext.viewController(forKey: .from),
            let presentedController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        takeSnapshotsOfViews(presentingController: presentingController)
        setupViews(presentedController, containerView)
        configureViews(presentingController, presentedController, containerView, transitionContext.finalFrame(for: presentedController))
        animate(presentingController, presentedController, transitionContext)
    }
    
    private func takeSnapshotsOfViews(presentingController: UIViewController) {
        miniPlayerController?.coverImageView.isHidden = true
        miniPlayerSnapshotView = miniPlayerController?.view.snapshotView(afterScreenUpdates: false) ?? UIView()
        
        if let tabBarController = presentingController as? UITabBarController {
            tabBarController.tabBar.isTranslucent = false
            tabBarSnapshotView = tabBarController.tabBar.snapshotView(afterScreenUpdates: false) ?? UIView()
        }
    }
    
    private func setupViews(_ presentedController: UIViewController, _ containerView: UIView) {
        containerView.addSubview(presentedController.view)
        containerView.addSubview(miniPlayerSnapshotView)
        containerView.addSubview(coverImageView)
        containerView.addSubview(tabBarSnapshotView)
        presentedController.view.addSubview(fadeView)
    }
    
    private func configureViews(_ presentingController: UIViewController, _ presentedController: UIViewController, _ containerView: UIView, _ presentedControllerFinalFrame: CGRect) {
        
        fadeView.frame = presentingController.view.bounds
        fadeView.backgroundColor = .white
        
        let presentedView: UIView = presentedController.view
        presentedView.frame = presentedControllerFinalFrame
        
        if let miniPlayer = miniPlayerController {
            presentedView.frame.origin.y = containerView.bounds.height - miniPlayer.view.bounds.height - getBottomInset(in: presentingController)
            miniPlayerSnapshotView.frame = miniPlayer.view.frame
    
            coverImageView.layer.masksToBounds = true
            coverImageView.layer.cornerRadius = miniPlayer.cornerRadius
            coverImageView.image = miniPlayerController?.coverImage
            coverImageView.contentMode = .scaleAspectFill
            coverImageView.frame = miniPlayer.coverImageView.convert(coverImageView.bounds, to: presentingController.view)
            coverImageView.frame.size = miniPlayer.coverImageView.bounds.size
        }
        
        if let tabBarController = presentingController as? UITabBarController {
            tabBarSnapshotView.frame = tabBarController.tabBar.frame
        }
    }
    
    private func getBottomInset(in viewController: UIViewController) -> CGFloat {
        var bottomInset = CGFloat.zero
    
        if let tabBarController = viewController as? UITabBarController {
            bottomInset = tabBarController.tabBar.bounds.height
        } else {
            bottomInset = viewController.view.safeAreaInsets.bottom
        }
        
        return bottomInset
    }
    
    private func animate(_ presentingViewController: UIViewController, _ presentedViewController: UIViewController, _ transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        
        func secondaryAnimation() {
            fadeView.alpha = 0.0
            miniPlayerSnapshotView.alpha = 0.0
        }
        
        func mainAnimation() {
            let finalFrame = transitionContext.finalFrame(for: presentedViewController)
            presentedViewController.view.frame = finalFrame
            coverImageView.frame.origin = presentedViewController.view.center
            miniPlayerSnapshotView.frame.origin = finalFrame.origin
            tabBarSnapshotView.frame.origin.y = finalFrame.maxY
        }
        
        func mainAnimationCompletion(_ finished: Bool) {
            coverImageView.removeFromSuperview()
            miniPlayerSnapshotView.removeFromSuperview()
            
            miniPlayerController?.coverImageView.isHidden = false
            if let tabBarController = presentingViewController as? UITabBarController {
                tabBarController.tabBar.isTranslucent = true
            }
            
            transitionContext.completeTransition(finished)
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: { mainAnimation() },
            completion: { mainAnimationCompletion($0) })
        
        UIView.animate(withDuration: duration * 0.2, animations: { secondaryAnimation() }, completion: { [fadeView] _ in
            fadeView.removeFromSuperview()
        })
    }
}

