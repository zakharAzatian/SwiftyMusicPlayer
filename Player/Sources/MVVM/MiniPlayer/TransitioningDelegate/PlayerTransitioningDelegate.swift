//
//  PlayerTransitioningDelegate.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private weak var miniPlayerController: MiniPlayerViewController?
    
    init(miniPlayerController: MiniPlayerViewController) {
        self.miniPlayerController = miniPlayerController
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PlayerPresentationConroller(presentedViewController: presented, presenting: presenting)
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PlayerPresentingAnimationController(miniPlayerController: miniPlayerController)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PlayerDismissingAnimationController()
    }
}
