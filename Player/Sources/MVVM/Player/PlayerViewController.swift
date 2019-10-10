//
//  PlayerViewController.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import UIKit
import RxSwift
import RxCocoa

class PlayerViewController: UIViewController {
    
    private let player: PlayerType = Player()
    var paused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.paused = !self.paused
            if self.paused {
                self.player.pause.accept(())
            } else {
                self.player.play.accept(())
            }
        }) 
        
        player.currentTime.emit(onNext: { time in
            print(time)
        })
        
        player.finishPlaying.emit(onNext: { _ in
            print("Finished")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = self.getURL() {
            self.player.startPlayTrack.accept(url)
        }
    }
    
    func getURL() -> URL? {
        return Bundle.main.url(forResource: "piano", withExtension: "mp3")
    }
}

