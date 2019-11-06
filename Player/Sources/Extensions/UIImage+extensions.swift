//
//  UIImage+extensions.swift
//  Player
//
//  Created by Zakhar Azatyan on 06.11.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func roundImage(color: UIColor, diameter: CGFloat, shadow: Bool) -> UIImage {
        
        //we will make circle with this diameter
        let edgeLen: CGFloat = diameter
        
        //circle will be created from UIView
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: edgeLen, height: edgeLen))
        circle.backgroundColor = color
        circle.clipsToBounds = true
        circle.isOpaque = false
        
        //in the layer we add corner radius to make it circle and add shadow
        circle.layer.cornerRadius = edgeLen/2
        
        if shadow {
            circle.layer.shadowColor = UIColor.gray.cgColor
            circle.layer.shadowOffset = .zero
            circle.layer.shadowRadius = 2
            circle.layer.shadowOpacity = 0.4
            circle.layer.masksToBounds = false
        }
        
        //we add circle to a view, that is bigger than circle so we have extra 10 points for the shadow
        let view = UIView(frame: CGRect(x: 0, y: 0, width: edgeLen + 10, height: edgeLen + 10))
        view.backgroundColor = UIColor.clear
        view.addSubview(circle)
        
        circle.center = view.center
        
        //here we are rendering view to image, so we can use it later
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
