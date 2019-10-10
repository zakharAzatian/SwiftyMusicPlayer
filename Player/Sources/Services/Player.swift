//
//  Player.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

protocol PlayerType {
    var startPlayTrack: PublishRelay<URL> { get }
    var play: PublishRelay<Void> { get }
    var pause: PublishRelay<Void> { get }
    var currentTime: Signal<CMTime> { get }
    var finishPlaying: Signal<Void> { get }
}

final class Player: PlayerType, ReactiveCompatible {
    let startPlayTrack = PublishRelay<URL>()
    let finishPlaying: Signal<Void>
    let play = PublishRelay<Void>()
    let pause = PublishRelay<Void>()
    let currentTime: Signal<CMTime>
    
    private let _finishPlaying = PublishRelay<Void>()
    private let _currentTime = PublishRelay<CMTime>()
    
    private let avPlayer = AVPlayer()
    private let disposeBag = DisposeBag()
    
    init() {
        finishPlaying = _finishPlaying.asSignal()
        currentTime = _currentTime.asSignal()
        
        startPlayTrack.bind(to: avPlayer.rx.playTrack).disposed(by: disposeBag)
        play.bind(to: avPlayer.rx.play).disposed(by: disposeBag)
        pause.bind(to: avPlayer.rx.pause).disposed(by: disposeBag)
        
        addPeriodicTimeObserver()
        addFinishPlayingObserfer()
    }
    
    func seek(to time: CMTime) {
        avPlayer.seek(to: time)
    }
    
    private func addFinishPlayingObserfer() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            self._currentTime.accept(time)
        }
    }
    
    @objc private func didFinishPlaying() {
        _finishPlaying.accept(())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
