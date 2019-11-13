//
//  CurrentRunVC.swift
//  HomeRun
//
//  Created by Nazar Petruk on 13/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC {
    
//MARK : IBOutlets
    
    @IBOutlet weak var swipeBGimageView: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(finishRunSwiped(sender:)))
        sliderImgView.addGestureRecognizer(swipeGesture)
        sliderImgView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate

    }
    
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
