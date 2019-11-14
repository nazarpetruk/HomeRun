//
//  CurrentRunVC.swift
//  HomeRun
//
//  Created by Nazar Petruk on 13/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {
    
//MARK : IBOutlets
    
    @IBOutlet weak var swipeBGimageView: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    @IBOutlet weak var runDurationLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
//MARK: VARS&LETS
    var startLoc : CLLocation!
    var lastLoc : CLLocation!
    var distance = 0.0
    
    var count = 0
    var timer = Timer()
    
    var pace = 0
    
    
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
    
//MARK: IBAction
    @IBAction func pauseBtnTapped(_ sender: Any) {
        
    }
    
//MARK: Func for Run
    func startRun() {
        manager?.startUpdatingLocation()
        startTimer()
    }
    
    func endRun() {
        manager?.startUpdatingLocation()
        stopTimer()
    }
    
//MARK: Func for timer
    func startTimer(){
        runDurationLbl.text = count.timeFormatter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter () {
        count += 1
        runDurationLbl.text = count.timeFormatter()
    }
    
    func stopTimer(){
        
    }
    
//MARK: Func for pace
    func calculatePace(time inSeconds: Int , distance inKm: Double) -> String {
        pace = Int(Double(inSeconds) / inKm)
        return pace.timeFormatter()
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
                    //END RUN CODE
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
            distanceLbl.text = "\(distance.mIntoKm(decimalNums: 3))"
            if count > 0 && distance > 0 {
                speedLbl.text = calculatePace(time: count, distance: distance.mIntoKm(decimalNums: 2))
            }
        }
        lastLoc = locations.last
    }
}
