//
//  ManagerDailyActiviy.swift
//  Farm
//
//  Created by Dhrubojyoti on 05/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class ManagerDailyActiviy: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyActivityCell", for: indexPath) as! ManagerDailyActivityCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }



}
