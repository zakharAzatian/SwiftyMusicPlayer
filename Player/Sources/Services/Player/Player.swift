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
    // in
    var startPlayTrack: PublishRelay<URL> { get }
    var seekTime: PublishRelay<CMTime> { get }
    var playTrigger: PublishRelay<Void> { get }
    var pause: PublishRelay<Void> { get }
    var play: PublishRelay<Void> { get }
    
    // out
    var duration: BehaviorRelay<CMTime> { get }
    var isPlaying: PublishRelay<Bool> { get }
    var currentTime: Signal<CMTime> { get }
    var finishPlaying: Signal<Void> { get }
    
}

final class Player: NSObject, PlayerType {
    // in
    let startPlayTrack = PublishRelay<URL>()
    let playTrigger = PublishRelay<Void>()
    let seekTime = PublishRelay<CMTime>()
    let pause = PublishRelay<Void>()
    let play = PublishRelay<Void>()
    
    // out
    let duration = BehaviorRelay<CMTime>(value: CMTime())
    let isPlaying = PublishRelay<Bool>()
    let finishPlaying: Signal<Void>
    let currentTime: Signal<CMTime>

    private let _finishPlaying = PublishRelay<Void>()
    private let _currentTime = PublishRelay<CMTime>()
    
    @objc private let avPlayer = AVPlayer()
    private let disposeBag = DisposeBag()
    
    private var currentPlayerItemObservation: NSKeyValueObservation?
    private var timeControlStatusObservation: NSKeyValueObservation?
      
    override init() {
        finishPlaying = _finishPlaying.asSignal()
        currentTime = _currentTime.asSignal()
        super.init()
        
        startPlayTrack.bind(to: avPlayer.rx.playTrack).disposed(by: disposeBag)
        
        pause.bind(to: avPlayer.rx.pause).disposed(by: disposeBag)
        play.bind(to: avPlayer.rx.play).disposed(by: disposeBag)
        seekTime.bind(to: avPlayer.rx.seek).disposed(by: disposeBag)
        
        playTrigger.withLatestFrom(isPlaying).subscribe(onNext: { [pause, play] value in
            value ? pause.accept(()) : play.accept(())
        }).disposed(by: disposeBag)
        
        addCurrentPlayerItemObserver()
        addTimeControlStatusObserver()
        addFinishPlayingObserver()
        addPeriodicTimeObserver()
    }
    
    func seek(to time: CMTime) {
        avPlayer.seek(to: time)
    }
    
    func getDuration() -> CMTime? {
        return avPlayer.currentItem?.asset.duration
    }
    
    private func addFinishPlayingObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        avPlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            self._currentTime.accept(time)
        }
    }
    
    private func addCurrentPlayerItemObserver() {
        currentPlayerItemObservation = observe(\.avPlayer.currentItem, changeHandler: { [avPlayer, duration] _, _ in
            var time = CMTime()
            
            if let item = avPlayer.currentItem {
                time = item.asset.duration
            }
            
            duration.accept(time)
        })
    }
    
    private func addTimeControlStatusObserver() {
        timeControlStatusObservation = observe(\.avPlayer.timeControlStatus, options: [.old, .new], changeHandler: { [avPlayer, isPlaying] _, _ in
            isPlaying.accept(avPlayer.timeControlStatus == .playing)
        })
    }
    
    @objc private func didFinishPlaying() {
        _finishPlaying.accept(())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
