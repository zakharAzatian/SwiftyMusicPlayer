//
//  PlayPauseButton.swift
//  Player
//
//  Created by Zakhar on 15.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PlayPauseButton: UIButton {
    
    var isPlaying: PublishRelay<Bool> {
        return viewModel.isPlaying
    }
    
    private let viewModel: PlayPauseViewModelType = PlayPauseViewModel()
    private let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        viewModel.image.emit(to: rx.image()).disposed(by: disposeBag)
    }
}
