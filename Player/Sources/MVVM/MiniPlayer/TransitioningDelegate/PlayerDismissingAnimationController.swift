//
//  PlayerDismissingAnimationController.swift
//  Player
//
//  Created by Zakhar Azatyan on 01.11.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerDismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private weak var miniPlayer: MiniPlayerViewController?
    
    private var miniPlayerSnapshotView: UIView?
    private var playerSnapshotView: UIView?
    
    private let coverImageView = UIImageView()
    private let playerBackground = UIView()
    
    init(miniPlayer: MiniPlayerViewController?) {
        self.miniPlayer = miniPlayer
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let playerController = transitionContext.viewController(forKey: .from) as? PlayerViewController, let miniPlayer = miniPlayer else {
            return
        }
        
        let containerView = transitionContext.containerView
        takeSnapshots(playerController: playerController, miniPlayer: miniPlayer)
        
        guard setupViews(containerView: containerView) else {
            print("ERROR: Views for animation not found")
            return
        }
        
        configureViews(playerController: playerController, miniPlayerController: miniPlayer)
        animate(transitionContext: transitionContext, containerView: containerView, miniPlayer, playerController)
    }
    
    private func takeSnapshots(playerController: PlayerViewController, miniPlayer: MiniPlayerViewController) {
        playerController.coverImageView.isHidden = true // we hide cover before snapshot
        let playerSnapshot = playerController.view.snapshotView(afterScreenUpdates: true)
        self.playerSnapshotView = playerSnapshot
        
        miniPlayer.coverImageView.isHidden = true
        miniPlayerSnapshotView = miniPlayer.view.snapshotView(afterScreenUpdates: true)
    }
    
    private func setupViews(containerView: UIView) -> Bool {
        guard let miniPlayerSnapShot = miniPlayerSnapshotView, let playerSnapshot = playerSnapshotView else { return false }
        containerView.insertSubview(playerBackground, at: 3) // TODO: Refactor without magic number 3, beause of tab bar
        containerView.insertSubview(playerSnapshot, aboveSubview: playerBackground)
        containerView.insertSubview(miniPlayerSnapShot, aboveSubview: playerSnapshot)
        containerView.insertSubview(coverImageView, aboveSubview: miniPlayerSnapShot)
        return true
    }
    
    private func configureViews(playerController: PlayerViewController, miniPlayerController: MiniPlayerViewController) {
        
        // Background Configuration
        playerBackground.frame = playerController.view.frame
        playerBackground.backgroundColor = playerController.view.backgroundColor
        
        // Mini Player Snapshot Configuration
        miniPlayerSnapshotView?.frame.size = miniPlayerController.view.frame.size
        miniPlayerSnapshotView?.frame.origin = playerController.view.frame.origin
        miniPlayerSnapshotView?.alpha = 0.0
        
        // Cover Image Configuration
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = playerController.cover
        coverImageView.frame = playerController.coverImageFrame
        coverImageView.layer.cornerRadius = playerController.coverCornerRadius
        coverImageView.layer.masksToBounds = true
        
        // Player Snapshot Configuration
        playerSnapshotView?.frame = playerController.view.frame
        playerSnapshotView?.backgroundColor = playerController.view.backgroundColor

    }
    
    private func animate(transitionContext: UIViewControllerContextTransitioning, containerView: UIView, _ miniPlayerController: MiniPlayerViewController, _ playerController: PlayerViewController) {
        
        let miniPlayerFrame = miniPlayerController.view.frame
        playerController.view.isHidden = true
        
        let animation: () -> Void = { [playerBackground, playerSnapshotView, miniPlayerSnapshotView, coverImageView] in
            playerBackground.frame.origin = miniPlayerFrame.origin
            playerSnapshotView?.frame.origin.y = playerBackground.frame.origin.y
            miniPlayerSnapshotView?.frame.origin.y = playerBackground.frame.origin.y
            coverImageView.frame = miniPlayerController.coverImageView.convert(miniPlayerController.coverImageView.bounds, to: containerView)
            coverImageView.cornerRadius = miniPlayerController.cornerRadius
            
            playerSnapshotView?.alpha = 0.0
            miniPlayerSnapshotView?.alpha = 1.0
        }
        
        let completion: (Bool) -> Void = {
            miniPlayerController.coverImageView.isHidden = false
            transitionContext.completeTransition($0)
        }
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
                    delay: 0,
                    usingSpringWithDamping: 1,
                    initialSpringVelocity: 1,
                    options: .curveEaseIn,
                    animations: animation, completion: completion)
    }
}

