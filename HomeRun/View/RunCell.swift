//
//  RunCell.swift
//  HomeRun
//
//  Created by Nazar Petruk on 15/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class RunCell: UITableViewCell {

//MARK: IBOutlets
    
    @IBOutlet weak var pacelbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configurecell(run : Run){
        durationLbl.text = run.duration.intoStringFormatter()
        distanceLbl.text = "\(run.distance.mIntoKm(decimalNums: 2)) /km"
        pacelbl.text = run.pace.intoStringFormatter()
        dateLbl.text = run.date.reformDateString()
        
    }
}
