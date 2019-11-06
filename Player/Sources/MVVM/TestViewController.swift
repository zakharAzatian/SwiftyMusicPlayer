//
//  TestViewController.swift
//  Player
//
//  Created by Zakhar on 14.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    let button = UIButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    let player = SwiftyMusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9303606153, green: 0.9260264039, blue: 0.9358182549, alpha: 1)
        
        view.addSubview(button)
        button.fill(in: view)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        let url = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
        player.addMiniPlayerTo(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @objc func tapped() {
    }
}
