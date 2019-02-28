//
//  adminFarmActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 28/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminFarmActivity: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
    }
    

    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }

}
