//
//  MiniPlayerViewModel.swift
//  Player
//
//  Created by Zakhar Azatyan on 04.11.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MiniPlayerViewModelType {
    // in
    var longTapTrigger: PublishRelay<UIGestureRecognizer.State> { get }
    var presentPlayerFromTrigger: PublishRelay<MiniPlayerViewController> { get }
    
    // out
    var backgroundColor: Signal<UIColor> { get }
    var isPlaying: Signal<Bool> { get }
    var presentPlayer: Signal<Void> { get }
    var coverImage: BehaviorRelay<UIImage> { get }
}

final class MiniPlayerViewModel: MiniPlayerViewModelType {
    let longTapTrigger = PublishRelay<UIGestureRecognizer.State>()
    let presentPlayerFromTrigger = PublishRelay<MiniPlayerViewController>()
    
    let backgroundColor: Signal<UIColor>
    let isPlaying: Signal<Bool>
    let presentPlayer: Signal<Void>
    let coverImage: BehaviorRelay<UIImage>
    
    private let isSelected: Signal<Bool>
    private let player: PlayerType
    
    private let disposeBag = DisposeBag()
    
    init(_ player: PlayerType) {
        let selectedColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        let cover = UIImage(named: "test")! // for testing
        
        self.player = player
        
        coverImage = BehaviorRelay(value: cover)
        isSelected = longTapTrigger.map({ return $0 == .began || $0 == .changed }).asSignal(onErrorSignalWith: .empty())
        backgroundColor = isSelected.map({ $0 ? selectedColor : .clear })
        isPlaying = player.isPlaying.asSignal(onErrorSignalWith: .empty())
        presentPlayer = longTapTrigger.filter({ $0 == .ended }).toVoid().asSignal(onErrorSignalWith: .empty())
        
        func presentPlayer(from controller: MiniPlayerViewController) {
            guard let vc = PlayerViewController.initialize() else {
                print("Can't init Player view controller from storyboard")
                return
            }

            let transitionDelegate = PlayerTransitioningDelegate(miniPlayerController: controller)
            vc.transitioningDelegate = transitionDelegate
            vc.modalPresentationStyle = .custom
            vc.cover = cover
            controller.present(vc, animated: true)
        }
        
        presentPlayerFromTrigger.subscribe(onNext: { presentPlayer(from: $0)} ).disposed(by: disposeBag)
    }
}
