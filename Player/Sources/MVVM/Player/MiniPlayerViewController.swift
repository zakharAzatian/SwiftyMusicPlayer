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

class MiniPlayerViewController: UIViewController {
    
    private let blurBackgroundView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let playPauseButton = PlayPauseButton()
    private let nameLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    let coverImageView = UIImageView()
    var coverImage: UIImage = UIImage(named: "test")! // Test image

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        configureViews()
        setupGestureRecognizers()
    }
    
    @discardableResult
    static func addMiniPlayerTo(viewController: UIViewController) -> MiniPlayerViewController {
        let player = MiniPlayerViewController()
        viewController.addChild(player)
        viewController.view.addSubview(player.view)
        player.didMove(toParent: viewController)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        player.view.translatesAutoresizingMaskIntoConstraints = false
        player.view.fillHorizontally(in: viewController.view)
        player.view.setBottom(to: viewController.view)
        player.view.setHeight(64)
        
        return player
    }
    
    private func setupViews() {
        view.addSubview(blurBackgroundView)
        view.addSubview(playPauseButton)
        view.addSubview(coverImageView)
        view.addSubview(nameLabel)
        
    }
    
    private func setupConstraints() {
        blurBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        let coverImageCornerRadius: CGFloat = 3.0
        coverImageView.layer.cornerRadius = coverImageCornerRadius
        coverImageView.layer.masksToBounds = true
        coverImageView.image = coverImage
    }
    
    private func setupGestureRecognizers() {
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = PlayerViewController()
            let transitionDelegate = PlayerTransitioningDelegate(miniPlayerController: self)
            vc.transitioningDelegate = transitionDelegate
            vc.modalPresentationStyle = .custom
            self.parent?.present(vc, animated: true)
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tap)
    }

}
