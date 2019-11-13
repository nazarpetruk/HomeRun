//
//  LocationVC.swift
//  HomeRun
//
//  Created by Nazar Petruk on 13/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController, MKMapViewDelegate {
    
//MARK: VARs
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.activityType = .fitness
        
    }
    func checkLocationAuthStatus () {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager?.requestWhenInUseAuthorization()
        }
    }
}


