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
    var isPlaying: Signal<Bool> { get }
    var tapTrigger: PublishRelay<Void> { get }
    var image: Signal<UIImage> { get }
}

struct PlayPauseViewModel: PlayPauseViewModelType {
    
    let tapTrigger = PublishRelay<Void>()
    let isPlaying: Signal<Bool>
    let image: Signal<UIImage>
    
    init() {
        let startIsPlayingState = false
        isPlaying = tapTrigger.scan(startIsPlayingState) { state, _ in
            return !state
        }.asSignal(onErrorSignalWith: .empty())
        image = isPlaying.startWith(startIsPlayingState).map({ $0 ? Assets.icons.play : Assets.icons.pause })
    }
}
