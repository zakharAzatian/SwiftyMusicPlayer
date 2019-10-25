//
//  UISlider+ThumbImage.swift
//  Player
//
//  Created by Zakhar on 24.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

extension UISlider {
    @IBInspectable var thumbImage: UIImage? {
        get {
            return currentThumbImage
        } set {
            setThumbImage(newValue, for: .normal)
        }
    }
}
