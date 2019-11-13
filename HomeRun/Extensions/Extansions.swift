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
