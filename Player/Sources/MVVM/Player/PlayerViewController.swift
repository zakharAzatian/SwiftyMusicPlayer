//
//  PlayerViewController.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import UIKit
import MediaPlayer
import RxSwift
import RxCocoa

class PlayerViewController: UIViewController {
    @IBOutlet private weak var playPauseButton: PlayPauseButton!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var timeLineSlider: TimeLineSlider!
    @IBOutlet private weak var volumeSliderContainer: UIView!
    
    private let volumeView = MPVolumeView()
    
    private let disposeBag = DisposeBag()
    private var viewModel: PlayerViewModelType?
    
    static func initialize() -> Self? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTargetToForTimeLineSlider()
        setupVolumeSlider()
        bindViewModel()
    }
    
    func setupViewModel(with player: PlayerType) {
        viewModel = PlayerViewModel(player: player)
    }
    
    private func setupVolumeSlider() {
        volumeView.showsVolumeSlider = true
        volumeSliderContainer.addSubview(volumeView)
        volumeView.fill(in: volumeSliderContainer)
    }
    
    private func setupTargetToForTimeLineSlider() {
        timeLineSlider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        playPauseButton.rx.tap.bind(to: viewModel.playTrigger).disposed(by: disposeBag)
        
        viewModel.isPlaying.emit(to: playPauseButton.isPlaying).disposed(by: disposeBag)
        viewModel.currentTime.emit(to: currentTimeLabel.rx.text).disposed(by: disposeBag)
        viewModel.duration.emit(to: durationLabel.rx.text).disposed(by: disposeBag)
        
        timeLineSlider.rx.value.bind(to: viewModel.timeLineTrigger).disposed(by: disposeBag)
        viewModel.timeLineValue.emit(to: timeLineSlider.rx.value).disposed(by: disposeBag)
    }
    
    @objc private func sliderMoved(_ slider: UISlider, _ event: UIEvent) {
        guard let touch = event.allTouches?.first else { return }

        switch touch.phase {
        case .began, .moved, .stationary:
            viewModel?.timeLineIsMovingByUser.accept(true)
        case .cancelled, .ended:
            viewModel?.timeLineIsMovingByUser.accept(false)
        default: break
        }
        
    }
}
