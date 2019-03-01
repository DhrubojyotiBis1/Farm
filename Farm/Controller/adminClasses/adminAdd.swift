//
//  adminAdd.swift
//  Farm
//
//  Created by Dhrubojyoti on 02/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminAdd: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var farmName = String()
    var size = String()
    var descriptions = String()
    var longitude = [String]()
    var latitude = [String]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminAddCell", for: indexPath) as! adminAddCell
        if indexPath.row == 0{
            cell.textField.placeholder = "Farm Name"
            farmName = cell.textField.text!
        }else if indexPath.row == 1{
            cell.textField.placeholder = "Size"
            size = cell.textField.text!
        }else if indexPath.row == 2{
            cell.textField.placeholder = "Description"
            descriptions = cell.textField.text!
        }else{
            cell.textField.placeholder = "Latitude \(indexPath.row - 2)"
            longitude.append(cell.textField.text!)
            latitude.append(cell.textField.text!)
        }
        
        
        return cell
    }
    @IBAction func createButtonPressed(_ sender: Any) {
        print(farmName)
        print(size)
        print(descriptions)
        print(latitude)
        print(longitude)
    }
}
