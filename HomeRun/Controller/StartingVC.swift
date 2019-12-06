//
//  FirstViewController.swift
//  HomeRun
//
//  Created by Nazar Petruk on 12/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class StartingVC: LocationVC {
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
//MARK: IBAction

    @IBAction func locationBtnPressed(_ sender: Any) {
        mapCentering()
    }
    
    @IBAction func cancelLastRunBtnPressed(_ sender: Any) {
        lastRunView.isHidden = true
        closeLastRunBtn.isHidden = true
        mapCentering()
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
        mapView.userTrackingMode = .none
        mapView.setRegion(centeringMapOnLastRunRegion(locations: lastRun.locations), animated: true)
        
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
            mapCentering()
        }
    }
// func for centering user position on viewMap
    func mapCentering() {
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
// setting coordinate region from previous run of user
    //
    func centeringMapOnLastRunRegion(locations : List<Location>) -> MKCoordinateRegion {
        guard let startingLocation = locations.first else {
            return MKCoordinateRegion()
        }
        var minLat = startingLocation.latitude
        var minLong = startingLocation.longitude
        var maxLat = minLat
        var maxLong = minLong
        
        for location in locations {
            minLat = min(minLat, location.latitude)
            minLong = min(minLong, location.longitude)
            maxLat = max(maxLat, location.latitude)
            maxLong = max(maxLong, location.longitude)
        }
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (maxLong + minLong)/2), span: MKCoordinateSpan(latitudeDelta:(maxLat - minLat) * 1.5, longitudeDelta: (maxLong - minLong) * 1.5))
    }
}

//MARK: Extensions

extension StartingVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
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

