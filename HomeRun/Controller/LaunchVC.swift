//
//  LaunchVC.swift
//  HomeRun
//
//  Created by Nazar Petruk on 06/12/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class LaunchVC : UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline:.now() + 4, execute: {
           self.performSegue(withIdentifier:"toMain",sender: self)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
