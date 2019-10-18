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
    
    let button = UIButton()
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.frame = view.bounds
        button.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)
    }
}
