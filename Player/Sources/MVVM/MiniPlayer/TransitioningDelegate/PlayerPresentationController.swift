//
//  PlayerPresentationController.swift
//  Player
//
//  Created by Zakhar on 17.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

class PlayerPresentationConroller: UIPresentationController {
    
    // MARK: - Properties
    private let backgroundView = UIView()
    private let gradeView = UIView()
    private var tabBarSnapshotView = UIView()
    private var presentingSnapshotView = UIView()
    
    private lazy var pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    
    private let cornerRadius: CGFloat = 10.0
    private let duration: Double = 0.6
     
    // MARK: - Presentation Controller Methods
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView, let window = containerView.window else { return }
        
        takeSnapshotsForPresentation()
        setupViews(in: containerView)
        configureViewsForPresentation(window: window)
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.gradeView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.presentingSnapshotView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            self.tabBarSnapshotView.frame.origin.y = self.presentingViewController.view.frame.maxY
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        var tabBarFrame = CGRect.zero
        if let tabBarController = presentingViewController as? UITabBarController {
            let tabBar = tabBarController.tabBar
            tabBarFrame = tabBar.convert(tabBar.bounds, to: presentingViewController.view)
        }
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.gradeView.alpha = 0.0
            self.tabBarSnapshotView.frame = tabBarFrame
            self.presentingSnapshotView.transform = .identity
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
    
    // MARK: - Custom Methods
    private func setupViews(in container: UIView) {
        container.addSubview(backgroundView)
        container.addSubview(presentingSnapshotView)
        container.addSubview(gradeView)
        container.addSubview(tabBarSnapshotView)
    }
    
    // MARK: - Presentaion Helper Methods
    private func takeSnapshotsForPresentation() {
        presentingSnapshotView = presentingViewController.view.snapshotView(afterScreenUpdates: false) ?? UIView()
        if let tabBarController = presentingViewController as? UITabBarController {
            tabBarSnapshotView = tabBarController.tabBar.snapshotView(afterScreenUpdates: false) ?? UIView()
        }
    }
    
    private func configureViewsForPresentation(window: UIWindow) {
        configureTabBarSnapshotView()
        backgroundView.backgroundColor = UIColor.black
        
        gradeView.frame = window.frame
        backgroundView.fill(in: window, toSafeArea: false)
        
        addCornerRadiusAnimation(for: presentingSnapshotView, cornerRadius: cornerRadius, duration: duration)
        addCornerRadiusAnimation(for: presentedView, cornerRadius: cornerRadius, duration: duration)
        presentingSnapshotView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    private func configureTabBarSnapshotView() {
        guard let tabBarController = presentingViewController as? UITabBarController else { return }
        
        let tabBar = tabBarController.tabBar
        let size = tabBarController.tabBar.frame.size
        let topLine = UIView() // top line for tab bar, because snpashot takes wihtout this line
        
        topLine.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        topLine.frame = CGRect(origin: .zero, size: CGSize(width: size.width, height: 0.5))
        
        tabBarSnapshotView.frame.size = size
        tabBarSnapshotView.frame = tabBar.convert(tabBar.bounds, to: presentingViewController.view)
        tabBarSnapshotView.addSubview(topLine)
    }
    
    // MARK: Dismissing Helper Methods
    
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

// MARK: - Gesture Recognizer Delegate
extension PlayerPresentationConroller: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.isEqual(pan) else {
            return false
        }
        
        return true
    }
}
