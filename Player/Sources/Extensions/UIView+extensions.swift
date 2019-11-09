//
//  UIView+extensions.swift
//  Player
//
//  Created by Zakhar Azatyan on 09.11.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit
 
extension UIView {
    
    func containsActiveControls() -> Bool {
        for view in subviews {
            if let control = view as? UIControl, control.isSelected || control.isHighlighted || control.isTracking {
                return true
                
            } else if view .containsActiveControls() {
                return true
            }
        }
        
        return false
    }
    
}
