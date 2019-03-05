//
//  adminDailyExpenses.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON


class adminDailyExpenses: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var purpose = [String]()
    var unit = [String]()
    var total = [String]()
    var supplier = [String]()
    var unitPrice = [String]()
    var descriptions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.allowsSelection = false
        networking()
        let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
        if type == 3 || type == 1 {
            addButton.tintColor = UIColor(white: 0.95, alpha: 1)
            addButton.isEnabled = false
        }

        
    }
    
    private func networking(){
        //TODO: Networking is done here :
        SVProgressHUD.show()
        let url = URL()
        Alamofire.request(url.dataUrl).responseJSON { (response) in
            if response.result.isSuccess{
                let userjson:JSON = JSON(response.result.value!)
                self.dataParsing(json: userjson)
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    
    private func dataParsing(json : JSON){
        for  i in 0...(json["dailyexpenses"].count - 1){
            purpose.append(json["dailyexpenses"][i]["purpose"].string!)
            unit.append(json["dailyexpenses"][i]["unit"].string!)
            supplier.append(json["dailyexpenses"][i]["supplier"].string!)
            total.append(json["dailyexpenses"][i]["total"].string!)
            unitPrice.append(json["dailyexpenses"][i]["unitprice"].string!)
            descriptions.append(json["dailyexpenses"][i]["description"].string!)
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purpose.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyExpensesCell", for: indexPath) as! adminDailyExpensesCell
        cell.purpose.text! = "Purpose: " + purpose[indexPath.row]
        cell.descriptions.text! = "Description: " + descriptions[indexPath.row]
        cell.total.text! = "Total: " + total[indexPath.row]
        cell.unitPrice.text! = "Unit price:" + unitPrice[indexPath.row]
        cell.unit.text! = "Unit:" + unit[indexPath.row]
        cell.supplier.text! = "Supplier: " + supplier[indexPath.row]
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        return cell
    }
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAddExpenses", sender: nil)
    }
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.networking()
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }

    
}
