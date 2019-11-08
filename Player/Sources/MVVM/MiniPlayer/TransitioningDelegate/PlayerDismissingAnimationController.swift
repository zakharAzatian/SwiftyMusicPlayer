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
    private var miniPlayerSnapshotView = UIView()
    private var playerSnapshotView = UIView()
    
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
        
        containerView.insertSubview(playerBackground, at: 3) // we insert background view below tab bar snapshot
        playerBackground.frame = playerController.view.frame
        playerBackground.backgroundColor = playerController.view.backgroundColor
        
        playerController.coverImageView.isHidden = true
        if let playerSnapshot = playerController.view.snapshotView(afterScreenUpdates: true) {
            containerView.insertSubview(playerSnapshot, aboveSubview: playerBackground)
            playerSnapshot.frame = playerController.view.frame
            playerSnapshot.backgroundColor = playerController.view.backgroundColor
            self.playerSnapshotView = playerSnapshot
        }
        
        miniPlayer.coverImageView.isHidden = true
        guard let snapshot = miniPlayer.view.snapshotView(afterScreenUpdates: true) else { return }
            
        containerView.insertSubview(snapshot, aboveSubview: playerSnapshotView)
        snapshot.frame.size = miniPlayer.view.frame.size
        snapshot.frame.origin = playerController.view.frame.origin
        snapshot.alpha = 0.0
        miniPlayerSnapshotView = snapshot
        
        let coverImageView = UIImageView()
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = playerController.cover
        coverImageView.frame = playerController.coverImageFrame
        coverImageView.layer.cornerRadius = playerController.coverCornerRadius
        coverImageView.layer.masksToBounds = true
        containerView.insertSubview(coverImageView, aboveSubview: snapshot)
        
        playerController.view.isHidden = true
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseIn,
            animations: { [weak playerBackground, weak miniPlayerSnapshotView, weak playerSnapshotView] in
                playerBackground?.frame.origin = miniPlayer.view.frame.origin
                playerSnapshotView?.frame.origin.y = playerBackground?.frame.origin.y ?? .zero
                miniPlayerSnapshotView?.frame.origin.y = playerBackground?.frame.origin.y ?? .zero
                coverImageView.frame = miniPlayer.coverImageView.convert(miniPlayer.coverImageView.bounds, to: containerView)
                coverImageView.cornerRadius = miniPlayer.cornerRadius
                
                self.playerSnapshotView.alpha = 0.0
                self.miniPlayerSnapshotView.alpha = 1.0
                
                playerController.view.frame.origin = miniPlayer.view.frame.origin
        }) { finished in
            miniPlayer.coverImageView.isHidden = false
            transitionContext.completeTransition(finished)
        }
    }
}

