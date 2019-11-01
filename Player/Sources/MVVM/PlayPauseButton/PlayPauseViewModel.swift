//
//  PlayPauseViewModel.swift
//  Player
//
//  Created by Zakhar on 15.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlayPauseViewModelType {
    // in
    var isPlaying: PublishRelay<Bool> { get }
    // out
    var image: Signal<UIImage> { get }
}

struct PlayPauseViewModel: PlayPauseViewModelType {
    let isPlaying = PublishRelay<Bool>()
    let image: Signal<UIImage>
    
    init() {
        let playingSignal = isPlaying.asSignal()
        image = playingSignal.map({ $0 ? Assets.icons.pause : Assets.icons.play })
    }
}
