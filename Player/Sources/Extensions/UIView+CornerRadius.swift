//
//  UIView+CornerRadius.swift
//  Player
//
//  Created by Zakhar on 24.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
