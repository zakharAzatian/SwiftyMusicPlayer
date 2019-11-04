//
//  SwiftyMusicPlayer.swift
//  Player
//
//  Created by Zakhar Azatyan on 04.11.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

final class SwiftyMusicPlayer {
    private let player: PlayerType = Player()
    
    init() {
    }

    @discardableResult
    func addMiniPlayerTo(viewController: UIViewController) -> MiniPlayerViewController {
            let playerController = MiniPlayerViewController(player: player)
            viewController.addChild(playerController)
            viewController.view.addSubview(playerController.view)
            playerController.didMove(toParent: viewController)
        
            // Constaints
            playerController.view.fillHorizontally(in: viewController.view)
            playerController.view.setBottom(to: viewController.view, toSafeArea: true)
            playerController.view.setHeight(64)
            
            return playerController
        }
}
