//
//  AVPlayer+extensions.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift

extension Reactive where Base: AVPlayer {
    var playTrack: Binder<URL> {
        return Binder(base) { player, url in
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
    }
    
    var play: Binder<Void> {
        return Binder(base) { player, _ in
            player.play()
        }
    }
    
    var pause: Binder<Void> {
        return Binder(base) { player, _ in
            player.pause()
        }
    }
    
    var seek: Binder<CMTime> {
        return Binder(base) { player, time in
            player.seek(to: time)
        }
    }
}
