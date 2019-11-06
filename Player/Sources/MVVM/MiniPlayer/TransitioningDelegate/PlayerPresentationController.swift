//
//  PlayerPresentationController.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

class PlayerPresentationConroller: UIPresentationController {
    
    private var snapshotView: UIView?
    private let snaphotViewContainer = UIView()
    private let backgroundView = UIView()
    private let gradeView = UIView()
    
    private let cornerRadius: CGFloat = 10.0
    private let duration: Double = 0.6
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = self.containerView, let window = containerView.window else { return }

        backgroundView.backgroundColor = UIColor.black
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(snaphotViewContainer)
        containerView.addSubview(gradeView)
        
        snaphotViewContainer.frame = presentingViewController.view.frame
        gradeView.frame = window.frame
        backgroundView.fill(in: window, toSafeArea: false)

        snapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: false)
        
        if let snapshotView = snapshotView {
            snaphotViewContainer.addSubview(snapshotView)
        }
        
        addCornerRadiusAnimation(for: snapshotView, cornerRadius: cornerRadius, duration: duration)
        addCornerRadiusAnimation(for: presentedView, cornerRadius: cornerRadius, duration: duration)
        snapshotView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.gradeView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.snapshotView?.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.snapshotView?.transform = .identity
        }, completion: nil)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let presentingViewFrame = presentingViewController.view.frame
        let size = CGSize(width: presentingViewFrame.width, height: presentingViewFrame.height * 0.93)
        return CGRect(origin: .init(x: .zero, y: presentingViewFrame.height - size.height), size: size)
    }
    
    private func addCornerRadiusAnimation(for view: UIView?, cornerRadius: CGFloat, duration: CFTimeInterval) {
        guard let view = view else { return }
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = view.layer.cornerRadius
        animation.toValue = cornerRadius
        animation.duration = duration
        view.layer.add(animation, forKey: "cornerRadius")
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
}
