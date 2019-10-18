//
//  PlayerTransitioningDelegate.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class PlayerTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    private let miniPlayerController: MiniPlayerViewController
    
    init(miniPlayerController: MiniPlayerViewController) {
        self.miniPlayerController = miniPlayerController
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PlayerPresentationConroller(presentedViewController: presented, presenting: presenting)
        return controller
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PlayerPresentingAnimationController(miniPlayerController: miniPlayerController)
    }
}
