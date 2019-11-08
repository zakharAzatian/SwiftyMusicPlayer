//
//  PlayerPresentationController.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

class PlayerPresentationConroller: UIPresentationController {
    
    private let snaphotViewContainer = UIView()
    private let backgroundView = UIView()
    private let gradeView = UIView()
    private var tabBarSnapshotView = UIView()
    private var snapshotView: UIView?
    
    private lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    
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
        guard let containerView = containerView else { return }
        
        var tabBarFrame = CGRect.zero
        if let tabBarController = presentingViewController as? UITabBarController, let tabBarSnapshot = tabBarController.tabBar.snapshotView(afterScreenUpdates: false) {
            let topLine = UIView() // top line for tab bar
            topLine.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            tabBarSnapshotView = tabBarSnapshot
            let size = tabBarController.tabBar.frame.size
            tabBarSnapshotView.frame.size = size
            tabBarSnapshotView.frame.origin = CGPoint(x: 0, y: tabBarController.view.frame.maxY)
            topLine.frame = CGRect(origin: .zero, size: CGSize(width: size.width, height: 0.5))
            tabBarFrame = tabBarController.tabBar.frame
            containerView.addSubview(tabBarSnapshotView)
            tabBarSnapshotView.addSubview(topLine)
            tabBarSnapshotView.backgroundColor = .blue
        }
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.gradeView.alpha = 0.0
            self.tabBarSnapshotView.frame = tabBarFrame
            self.snapshotView?.transform = .identity
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        pan.delegate = self
        pan.maximumNumberOfTouches = 1
        pan.cancelsTouchesInView = false
        presentedViewController.view.addGestureRecognizer(pan)
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
    
    @objc private func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        guard gestureRecognizer.isEqual(pan) else {
            return
        }
        
        let translation = gestureRecognizer.translation(in: presentedView)
        let dismissThreshold: CGFloat = 240
        
        switch gestureRecognizer.state {
        case .began:
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: containerView)
        
        case .changed:
                updatePresentedViewForTranslation(inVerticalDirection: translation.y, dismissThreshold: dismissThreshold)
        
        case .ended:
            if translation.y >= dismissThreshold {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(
                    withDuration: 0.25,
                    animations: {
                        self.presentedView?.transform = .identity
                })
            }
        default: break
            
        }
    }
    
    private func updatePresentedViewForTranslation(inVerticalDirection translation: CGFloat, dismissThreshold: CGFloat = 240) {
        let elasticThreshold: CGFloat = 120
        
        let translationFactor: CGFloat = 1 / 2

        if translation >= 0 {
            let translationForModal: CGFloat = {
                if translation >= elasticThreshold {
                    let frictionLength = translation - elasticThreshold
                    let frictionTranslation = 30 * atan(frictionLength / 120) + frictionLength / 10
                    return frictionTranslation + (elasticThreshold * translationFactor)
                } else {
                    return translation * translationFactor
                }
            }()
            
            presentedView?.transform = CGAffineTransform(translationX: 0, y: translationForModal)
        }
    }
}

extension PlayerPresentationConroller: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.isEqual(pan) else {
            return false
        }
        
        return true
    }
}
