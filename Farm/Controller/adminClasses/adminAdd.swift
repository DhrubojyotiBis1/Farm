//
//  adminAdd.swift
//  Farm
//
//  Created by Dhrubojyoti on 02/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminAdd: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet var boundryView: UIView!
    var farmName = UITextField()
    var size = UITextField()
    var descriptions = UITextField()
    var latitude = [UITextField]()
    var longitude = [UITextField]()
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldDidEndEditing))
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
//        boundryView.addGestureRecognizer(tapGesture)
        
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminAddCell", for: indexPath) as! adminAddCell
        cell.textField.delegate = self
        if indexPath.row == 0{
            cell.textField.placeholder = "Farm Name"
            farmName = cell.textField
        }else if indexPath.row == 1{
            cell.textField.placeholder = "Size"
            size = cell.textField
        }else if indexPath.row == 2{
            cell.textField.placeholder = "Description"
            descriptions = cell.textField
        }else{
            if indexPath.row%2 == 0 {
                cell.textField.placeholder = "Latitude \(indexPath.row - 2)"
                latitude.append(cell.textField)
            }else{
                cell.textField.placeholder = "longitude \(indexPath.row - 2)"
                longitude.append(cell.textField)
            }
        }
        
        return cell
    }

    @IBAction func createButtonPressed(_ sender: Any) {
        print(farmName.text!)
        print(size.text!)
        print(descriptions.text!)
        print(latitude[0].text!)
        print(longitude[0].text!)
    }
}
