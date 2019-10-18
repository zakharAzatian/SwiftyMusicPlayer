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
    
    private let cornerRadius: CGFloat = 10.0
    private let duration: Double = 0.6
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView, let window = containerView.window else { return }

        backgroundView.backgroundColor = UIColor.black
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        snaphotViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(snaphotViewContainer)
        
        snaphotViewContainer.frame = presentingViewController.view.frame
        backgroundView.fill(in: window, toSafeArea: false)

        snapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: false)
        
        if let snapshotView = snapshotView {
            snaphotViewContainer.addSubview(snapshotView)
        }
        
        addCornerRadiusAnimation(for: snapshotView, cornerRadius: cornerRadius, duration: duration)
        addCornerRadiusAnimation(for: presentedView, cornerRadius: cornerRadius, duration: duration)
        snapshotView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.snapshotView?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
        
        return CGRect(origin: CGPoint(x: .zero, y: presentingViewFrame.height - size.height), size: size)
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
