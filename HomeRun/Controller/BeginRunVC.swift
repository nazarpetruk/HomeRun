//
//  FirstViewController.swift
//  HomeRun
//
//  Created by Nazar Petruk on 12/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import MapKit

class BeginRunVC: LocationVC {
    
//MARK: IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
        
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    
//MARK: IBAction
    @IBAction func locationBtnPressed(_ sender: Any) {
    }
    
    
}

//MARK: Extensions

extension BeginRunVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
}

