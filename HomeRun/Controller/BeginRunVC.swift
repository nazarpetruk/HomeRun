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
        mapView.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapConfig()
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
    func addLastRunPolyline() -> MKPolyline? {
        guard let lastRun = Run.getRuns()?.first else {
            return nil
        }
        paceLbl.text = lastRun.pace.intoStringFormatter()
        distanceLbl.text = "\(lastRun.distance.mIntoKm(decimalNums: 2)) /km"
        timeRunLbl.text = lastRun.duration.intoStringFormatter()
        
        var cordinates = [CLLocationCoordinate2D]()
        for location in lastRun.locations {
            cordinates.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        return MKPolyline(coordinates: cordinates, count: lastRun.locations.count)
    }
    
    func mapConfig() {
        if let overlay = addLastRunPolyline() {
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunView.isHidden = false
            closeLastRunBtn.isHidden = false
        }else{
            lastRunView.isHidden = true
            closeLastRunBtn.isHidden = true
        }
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           let line = overlay as! MKPolyline
           let render = MKPolylineRenderer(polyline: line)
           render.strokeColor = #colorLiteral(red: 0.4803189635, green: 0.04282506555, blue: 0.0762879774, alpha: 1)
           render.lineWidth = 5
           return render
       }
}

