//
//  SecondViewController.swift
//  HomeRun
//
//  Created by Nazar Petruk on 12/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class RunHistoryVC: UIViewController {

    
//MARK : IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
}
//MARK: Extensions

extension RunHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? RunCell {
            guard let run = Run.getRuns()?[indexPath.row] else {
               return RunCell ()
            }
            
//            cell.layer.borderWidth = 2
//            cell.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//            cell.layer.cornerRadius = 20
//            cell.layer.masksToBounds = true
            
            cell.configurecell(run: run)
            return cell
        }else{
            return RunCell()
        }
    }
}

