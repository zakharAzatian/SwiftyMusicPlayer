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
    
    private var coverImageView = UIImageView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        view.addSubview(button)
        button.frame = view.bounds
        button.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)
    }
}
