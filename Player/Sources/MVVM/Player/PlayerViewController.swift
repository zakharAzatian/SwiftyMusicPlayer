//
//  PlayerViewController.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit
import MediaPlayer
import RxSwift
import RxCocoa

class PlayerViewController: UIViewController {
    @IBOutlet private weak var playPauseButton: PlayPauseButton!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var timeLineSlider: TimeLineSlider!
    @IBOutlet private weak var volumeSliderContainer: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    private let volumeView = MPVolumeView()
    
    private let disposeBag = DisposeBag()
    private var viewModel: PlayerViewModelType?
    
    var cover: UIImage?
    let coverCornerRadius: CGFloat = 10.0
    var coverImageFrame: CGRect {
        let size = view.bounds.width * 0.7
        let origin = CGPoint(x: (view.bounds.width - size) / 2, y: coverImageView.convert(coverImageView.frame.origin, to: view.window).y)
        return CGRect(origin: origin, size: CGSize(width: size, height: size))
    }

    static func initialize() -> Self? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        
        tap.rx.event.subscribe(onNext: { _ in
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        coverImageView.image = cover
        setupTargetToForTimeLineSlider()
        setupVolumeSlider()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coverImageView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coverImageView.isHidden = false
    }
    
    func setupViewModel(with player: PlayerType) {
        viewModel = PlayerViewModel(player: player)
    }
    
    private func setupVolumeSlider() {
        volumeView.showsRouteButton = false
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
