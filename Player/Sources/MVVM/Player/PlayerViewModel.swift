//
//  PlayerViewModel.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

protocol PlayerViewModelType {
    // in
    var playTrigger: PublishRelay<Void> { get }
    var timeLineTrigger: PublishRelay<Float> { get }
    var timeLineIsMovingByUser: BehaviorRelay<Bool> { get }
    
    // out
    var isPlaying: Signal<Bool> { get }
    var currentTime: Signal<String> { get }
    var duration: Signal<String>  { get }
    var timeLineValue: Signal<Float> { get }
}

class PlayerViewModel: PlayerViewModelType {

    // in
    let playTrigger = PublishRelay<Void>()
    let timeLineTrigger = PublishRelay<Float>()
    let timeLineIsMovingByUser = BehaviorRelay<Bool>(value: false)
    
    // out
    let duration: Signal<String>
    let isPlaying: Signal<Bool>
    let currentTime: Signal<String>
    let timeLineValue: Signal<Float>
    
    // inner propeties
    private let disposeBag = DisposeBag()
    private let player = Player()
    private let seekTime: Signal<CMTime>

    init(player: PlayerType) {
        let seekingCurrentTime = Observable<(String, Bool)>.combineLatest(player.duration, timeLineTrigger, timeLineIsMovingByUser, resultSelector: { duration, timelineValue, isMoving in
            let seconds = duration.seconds * Double(timelineValue)
            let time = CMTime(seconds: seconds, preferredTimescale: 1000)
            return (time.timeLineString, isMoving)
        }).filter({ $0.1 }).map{ $0.0 }.asSignal(onErrorSignalWith: .empty())
        
        isPlaying = player.isPlaying.asSignal()
        currentTime = .merge(
            player.currentTime.map { $0.timeLineString },
            seekingCurrentTime
        )
        duration = player.duration.map({ $0.timeLineString }).asSignal(onErrorSignalWith: .empty())
        
        timeLineValue = Signal<(Float, Bool)>.combineLatest(
            player.duration.asSignal(onErrorSignalWith: .empty()),
            player.currentTime,
            timeLineIsMovingByUser.delay(.milliseconds(100), scheduler: MainScheduler.instance).asSignal(onErrorSignalWith: .empty()),
            resultSelector: { duration, currentTime, isMoving in
                let value = Float(currentTime.seconds / duration.seconds)
                return (value, isMoving)
        }).filter({ !$0.1 }).map{ $0.0 }
        
        seekTime = Signal<(CMTime, Bool)>.combineLatest(
            player.duration.asSignal(onErrorSignalWith: .empty()),
            timeLineTrigger.asSignal().skip(1), // We skip 1 becase Slider.rx.value emits start value 0.0, when view model inits, we don't need it
            timeLineIsMovingByUser.asSignal(onErrorSignalWith: .empty()),
            resultSelector: { duration, timelineValue, isMoving in
                let seconds = duration.seconds * Double(timelineValue)
                let time = CMTime(seconds: seconds, preferredTimescale: 1000)
                return (time, isMoving)
        }).filter({ !$0.1 }).map{ $0.0 }
        

        seekTime.emit(to: player.seekTime).disposed(by: disposeBag)
        playTrigger.bind(to: player.playTrigger).disposed(by: disposeBag)
    }
}
