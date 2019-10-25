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
    
    private let blurBackgroundView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blur)
        return view
    }()
    
    private let playPauseButton = PlayPauseButton()
    private let nameLabel = UILabel()
    private let disposeBag = DisposeBag()
    
    private let selectedColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
     
    private var isSelected = false {
        didSet {
            view.backgroundColor = isSelected ? selectedColor : .clear
        }
    }
    
    let coverImageView = UIImageView()
    let cornerRadius: CGFloat = 3.0
    let coverImageViewContentMode: UIImageView.ContentMode = .scaleAspectFill
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
    
        player.view.fillHorizontally(in: viewController.view)
        player.view.setBottom(to: viewController.view, toSafeArea: true)
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
        coverImageView.image = coverImage
    }
    
    private func setupGestureRecognizers() {
        let longTap = UILongPressGestureRecognizer()
        longTap.minimumPressDuration = 0.0
        longTap.delegate = self
        
        view.addGestureRecognizer(longTap)
        
        longTap.rx.event.subscribe(onNext: { gesture in
            self.handleLongTapState(gesture.state)
        }).disposed(by: disposeBag)
    }
    
    private func handleLongTapState(_ state: UIGestureRecognizer.State) {
        switch state {
        case .began, .changed:
            isSelected = true
        case .ended:
            presentPlayer()
        default:
            isSelected = false
        }
    }
    
    private func presentPlayer() {
        guard let vc = PlayerViewController.initialize() else {
            print("Can't init Player view controller from storyboard")
            return
        }
        
        let transitionDelegate = PlayerTransitioningDelegate(miniPlayerController: self)
        vc.transitioningDelegate = transitionDelegate
        vc.modalPresentationStyle = .custom
        parent?.present(vc, animated: true, completion: { [weak self] in
            self?.isSelected = false
        })
    }
}

extension MiniPlayerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
}	
