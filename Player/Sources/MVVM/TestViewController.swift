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
    var cont: MiniPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.fill(in: view)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        cont = MiniPlayerViewController.addMiniPlayerTo(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Correct Frame: ", cont?.view.frame)
    }
    
    
    @objc func tapped() {
    }
}
