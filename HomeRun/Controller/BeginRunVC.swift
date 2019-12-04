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
    @IBOutlet weak var startRunBtn: UIButton!
    @IBOutlet weak var closeLastRunBtn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeRunLbl: UILabel!
    @IBOutlet weak var lastRunView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
        
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        lastRunView.layer.cornerRadius = 10
        lastRunView.layer.masksToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    
//MARK: IBAction

    @IBAction func locationBtnPressed(_ sender: Any) {
    }
    
    @IBAction func cancelLastRunBtnPressed(_ sender: Any) {
        lastRunView.isHidden = true
        closeLastRunBtn.isHidden = true
    }
    
    
//MARK: Funcs
    func getLastRun(){
        guard let lastRun = Run.getRuns()?.first else {
            lastRunView.isHidden = true
            closeLastRunBtn.isHidden = true
            return
        }
        lastRunView.isHidden = false
        closeLastRunBtn.isHidden = false
        paceLbl.text = lastRun.pace.intoStringFormatter()
        distanceLbl.text = "\(lastRun.distance.mIntoKm(decimalNums: 2)) /km"
        timeRunLbl.text = lastRun.duration.intoStringFormatter()
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

