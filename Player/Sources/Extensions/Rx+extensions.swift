//
//  Rx+extensions.swift
//  Player
//
//  Created by Zakhar Azatyan on 29.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import RxSwift

extension ObservableType {
    func toVoid() -> Observable<Void> {
        return self.map { _ in }
    }
}
