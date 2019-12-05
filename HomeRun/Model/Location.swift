//
//  Location.swift
//  HomeRun
//
//  Created by Nazar Petruk on 05/12/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
