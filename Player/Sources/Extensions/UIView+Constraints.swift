//
//  UIView+extensions.swift
//  Player
//
//  Created by Zakhar on 15.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

extension UIView {
    func fill(in view: UIView, padding: CGFloat = 0.0, toSafeArea: Bool = true) {
        setTop(to: view, padding, toSafeArea: toSafeArea)
        setBottom(to: view, padding, toSafeArea: toSafeArea)
        setLeading(to: view, padding, toSafeArea: toSafeArea)
        setTrailing(to: view, padding, toSafeArea: toSafeArea)
    }
    
    func fillHorizontally(in view: UIView, padding: CGFloat = 0.0) {
        setLeading(to: view, padding)
        setTrailing(to: view, padding)
    }
    
    func fillVertically(in view: UIView, padding: CGFloat = 0.0, toSafeArea: Bool = true) {
        setTop(to: view, padding, toSafeArea: toSafeArea)
        setBottom(to: view, padding, toSafeArea: toSafeArea)
    }
    
    func setLeading(to view: UIView, _ value: CGFloat, toSafeArea: Bool = true) {
        let anchor = toSafeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
        leadingAnchor.constraint(equalTo: anchor, constant: value).isActive = true
    }
    
    func setTrailing(to view: UIView, _ value: CGFloat, toSafeArea: Bool = true) {
        let anchor = toSafeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
        trailingAnchor.constraint(equalTo: anchor, constant: value).isActive = true
    }
    
    func setHeight(_ value: CGFloat) {
        heightAnchor.constraint(equalToConstant: value).isActive = true
    }
    
    func setHeight(equalTo view: UIView) {
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func setWidth(_ value: CGFloat) {
        widthAnchor.constraint(equalToConstant: value).isActive = true
    }
    
    func setWidth(equalTo view: UIView) {
        heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func centeredY(in view: UIView, _ value: CGFloat = 0.0) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: value).isActive = true
    }
    
    func setBottom(to view: UIView, _ value: CGFloat = 0.0, toSafeArea: Bool = true) {
        let anchor = toSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
        bottomAnchor.constraint(equalTo: anchor, constant: value).isActive = true
    }
    
    func setTop(to view: UIView, _ value: CGFloat = 0.0, toSafeArea: Bool = true) {
        let anchor = toSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
        topAnchor.constraint(equalTo: anchor, constant: value).isActive = true
    }
    
    func squared(_ value: CGFloat) {
        setWidth(value)
        setHeight(value)
    }
}
