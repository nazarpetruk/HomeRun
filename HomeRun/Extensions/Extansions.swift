//
//  Extansions.swift
//  HomeRun
//
//  Created by Nazar Petruk on 13/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import Foundation

extension Double {
    func mIntoKm(decimalNums: Int) -> Double {
        let div = pow(10.0, Double(decimalNums))
        return ((self / 1000) * div).rounded() / div
    }
}

extension Int {
    func timeFormatter() -> String {
        let durationInHours = self / 3600
        let durationInMinutes = (self % 3600) / 60
        let durationInsec = (self % 3600) % 60
        
        if durationInsec < 0 {
            return "00:00:00"
        }else{
            if durationInHours == 0 {
                return String(format: "%02d:%02d", durationInMinutes, durationInsec)
            }else{
                return String(format: "%02d:%02d:%02d", durationInHours, durationInMinutes, durationInsec)
            }
        }
    }
}
