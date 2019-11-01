//
//  CMTime+extensions.swift
//  Player
//
//  Created by Zakhar Azatyan on 29.10.2019.
//  Copyright © 2019 ZakharAzatian. All rights reserved.
//

import AVFoundation

extension CMTime {
    var minutes: Int {
        return Int(round(seconds).truncatingRemainder(dividingBy: 3600) / 60)
    }
    
    var second: Int {
        return Int(round(seconds).truncatingRemainder(dividingBy: 60))
    }
    
    var timeLineString: String {
        var minutesString = String(minutes)
               var secondsString = String(second)
               
               if minutesString.count < 2 {
                   minutesString.insert("0", at: minutesString.startIndex)
               }
               
               if secondsString.count < 2 {
                   secondsString.insert("0", at: secondsString.startIndex)
               }
               
               return "\(minutesString):\(secondsString)"
    }
}
