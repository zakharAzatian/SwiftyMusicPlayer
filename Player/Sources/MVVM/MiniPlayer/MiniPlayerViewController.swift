
//
//  MiniPlayerViewController.swift
//  Player
//
//  Created by Zakhar on 14.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: Fix appearance with tab bar

class MiniPlayerViewController: UIViewController {
    
    // MARK: - UI Elements
    private let blurBackgroundView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let nameLabel = UILabel()
    private let longTap = UILongPressGestureRecognizer()
    
    let playPauseButton = PlayPauseButton()
    let coverImageView = UIImageView()

    // MARK: - Other properties
    let viewModel: MiniPlayerViewModelType
    
    let disposeBag = DisposeBag()
    
    let cornerRadius: CGFloat = 3.0
    let coverImageViewContentMode: UIImageView.ContentMode = .scaleAspectFill
    
    // MARK: - Life cycle methods
    init(player: PlayerType) {
        viewModel = MiniPlayerViewModel(player)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureViews()
        setupGestureRecognizers()
        bindViewModel()
    }
    
    // MARK: - Other Methods
    private func bindViewModel() {
        longTap.rx.event.map({ $0.state }).bind(to: viewModel.longTapTrigger).disposed(by: disposeBag)
        viewModel.backgroundColor.emit(to: view.rx.backgroundColor).disposed(by: disposeBag)
        viewModel.isPlaying.emit(to: playPauseButton.isPlaying).disposed(by: disposeBag)
        viewModel.presentPlayer.map({ self }).emit(to: viewModel.presentPlayerFromTrigger).disposed(by: disposeBag)
        viewModel.coverImage.bind(to: coverImageView.rx.image).disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(blurBackgroundView)
        view.addSubview(playPauseButton)
        view.addSubview(coverImageView)
        view.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        blurBackgroundView.fill(in: view, toSafeArea: false)
        
        playPauseButton.fillVertically(in: view, toSafeArea: false)
        playPauseButton.setTrailing(to: view, -30)
        playPauseButton.setWidth(20)
        
        coverImageView.setLeading(to: view, 20)
        coverImageView.centeredY(in: view)
        coverImageView.squared(48)
        
        nameLabel.setLeading(to: coverImageView, 16)
        nameLabel.setHeight(equalTo: view)
        nameLabel.setTrailing(to: view, 16)
    }
    
    private func configureViews() {
        coverImageView.contentMode = coverImageViewContentMode
        coverImageView.layer.cornerRadius = cornerRadius
        coverImageView.layer.masksToBounds = true
    }
    
    private func setupGestureRecognizers() {
        longTap.minimumPressDuration = 0.0
        longTap.delegate = self
        view.addGestureRecognizer(longTap)
    }
}

extension MiniPlayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
}	
