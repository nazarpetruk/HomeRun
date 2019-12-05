//
//  CurrentRunVC.swift
//  HomeRun
//
//  Created by Nazar Petruk on 13/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentRunVC: LocationVC {
    
//MARK : IBOutlets
    
    @IBOutlet weak var swipeBGimageView: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    @IBOutlet weak var runDurationLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
//MARK: VARS&LETS
    fileprivate var startLoc : CLLocation!
    fileprivate var lastLoc : CLLocation!
    fileprivate var distance = 0.0
    fileprivate var coordinateLocations = List<Location>()
    fileprivate var count = 0
    fileprivate var timer = Timer()
    
    fileprivate var pace = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(finishRunSwiped(sender:)))
        sliderImgView.addGestureRecognizer(swipeGesture)
        sliderImgView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10
        startRun()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
//MARK: IBAction
    @IBAction func pauseBtnTapped(_ sender: Any) {
        if timer.isValid {
            pauseRun()
        }else{
            startRun()
        }
    }
    
//MARK: Func for Run
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
        pauseBtn.setImage(UIImage(named: "pauseButton"), for: .normal)
    }
    
    func endRun() {
        manager?.stopUpdatingLocation()
        Run.addFinishedRun(pace: pace, distance: distance, duration: count, locations: coordinateLocations)

    }
    
    func pauseRun() {
        startLoc = nil
        lastLoc = nil
        timer.invalidate()
        manager?.stopUpdatingLocation()
        pauseBtn.setImage(UIImage(named: "resumeButton"), for: .normal)
    }
    
//MARK: Func for timer
    func startTimer(){
        runDurationLbl.text = count.intoStringFormatter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter () {
        count += 1
        runDurationLbl.text = count.intoStringFormatter()
    }
    
//MARK: Func for pace
    func calculatePace(time inSeconds: Int , distance inKm: Double) -> String {
        pace = Int(Double(inSeconds) / inKm)
        return pace.intoStringFormatter()
    }
    
//MARK: Swiping Func
    @objc func finishRunSwiped(sender : UIPanGestureRecognizer) {
        let min : CGFloat = 80
        let max : CGFloat = 128
        if let sliderView = sender.view {
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
                let translation = sender.translation(in: self.view)
                if sliderView.center.x >= (swipeBGimageView.center.x - min) && sliderView.center.x <= (swipeBGimageView.center.x + max) {
                    sliderView.center.x = sliderView.center.x + translation.x
                }else if sliderView.center.x >= (swipeBGimageView.center.x + max){
                    sliderView.center.x = swipeBGimageView.center.x + max
                    endRun()
                    dismiss(animated: true, completion: nil)
                }else{
                    sliderView.center.x = swipeBGimageView.center.x - min
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.swipeBGimageView.center.x - min
                }
            }
        }
    }

}
//MARK: Extensions
extension CurrentRunVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLoc == nil {
            startLoc = locations.first
        }else if let location = locations.last {
            distance += lastLoc.distance(from: location)
            let newLocation = Location(latitude: Double(lastLoc.coordinate.latitude), longitude: Double(lastLoc.coordinate.longitude))
            coordinateLocations.insert(newLocation, at: 0)
            distanceLbl.text = "\(distance.mIntoKm(decimalNums: 3))"
            if count > 0 && distance > 0 {
                speedLbl.text = calculatePace(time: count, distance: distance.mIntoKm(decimalNums: 2))
            }
        }
        lastLoc = locations.last
    }
}
