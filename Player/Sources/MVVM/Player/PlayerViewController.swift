//
//  PlayerViewController.swift
//  Player
//
//  Created by Zakhar on 10.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation
import UIKit
import RxSwift
import RxCocoa

class PlayerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    static func initialize() -> Self? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        return storyboard.instantiateInitialViewController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
