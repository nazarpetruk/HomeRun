//
//  SecondViewController.swift
//  HomeRun
//
//  Created by Nazar Petruk on 12/11/2019.
//  Copyright © 2019 Nazar Petruk. All rights reserved.
//

import UIKit

class RunLegacyVC: UIViewController {

    
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

extension RunLegacyVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.getRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? RunCell {
            guard let run = Run.getRuns()?[indexPath.row] else {
               return RunCell ()
            }
            cell.configurecell(run: run)
            return cell
        }else{
            return RunCell()
        }
    }
}

