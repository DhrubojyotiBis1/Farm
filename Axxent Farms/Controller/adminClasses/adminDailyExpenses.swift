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

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    var purpose = [String]()
    var unit = [String]()
    var total = [String]()
    var supplier = [String]()
    var unitPrice = [String]()
    var indexPath = [Int]()
    var searchVisible = false
    var descriptions = [String]()
    var flag = 0
    
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
        
        let svProgressHudCheck = checkForSVProgressHUD()
        svProgressHudCheck.checkForSVProgressHUD(withFlag: flag)
        searchTextView.isHidden = true
        searchTextView.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        indexPath.removeAll()
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let svProgressHudCheck = checkForSVProgressHUD()
        svProgressHudCheck.checkForSVProgressHUD(withFlag: flag)
        self.tabBarController!.tabBar.isHidden = false
        searchTextView.isHidden = true

    }
    
    private func networking(){
        //TODO: Networking is done here :
        SVProgressHUD.show()
        let url = Url()
        Alamofire.request(url.dataUrl).responseJSON { (response) in
            if response.result.isSuccess{
                let userjson:JSON = JSON(response.result.value!)
                self.dataParsing(json: userjson)
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection", tag: 0)
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
        flag = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexPath.count > 0{
            return indexPath.count
        }else{
            return purpose.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyExpensesCell", for: indexPath) as! adminDailyExpensesCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        SVProgressHUD.dismiss()
        if self.indexPath.count > 0{
            cell.purpose.text! = "Purpose: " + purpose[self.indexPath[indexPath.row]]
            cell.descriptions.text! = "Description: " + descriptions[self.indexPath[indexPath.row]]
            cell.total.text! = "Total: " + total[self.indexPath[indexPath.row]]
            cell.unitPrice.text! = "Unit price:" + unitPrice[self.indexPath[indexPath.row]]
            cell.unit.text! = "Unit:" + unit[self.indexPath[indexPath.row]]
            cell.supplier.text! = "Supplier: " + supplier[self.indexPath[indexPath.row]]
            return cell
        }else{
            cell.purpose.text! = "Purpose: " + purpose[indexPath.row]
            cell.descriptions.text! = "Description: " + descriptions[indexPath.row]
            cell.total.text! = "Total: " + total[indexPath.row]
            cell.unitPrice.text! = "Unit price:" + unitPrice[indexPath.row]
            cell.unit.text! = "Unit:" + unit[indexPath.row]
            cell.supplier.text! = "Supplier: " + supplier[indexPath.row]
            return cell
        }
    }
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAddExpenses", sender: nil)
    }
    
    @IBAction func searchButtonPessed(_ sender: Any) {
        indexPath.removeAll()
        if searchVisible == false{
            searchTextView.isHidden = false
            searchTextView.isEnabled = true
            searchVisible = true
            print("Entered")
            cancelButton.isEnabled = true
            cancelButton.title = "Cancel"
            cancelButton.tintColor = UIColor.darkGray
        }else{
            //according to the search reload the table view
            
            if searchTextView.text! == ""{
                showAlertForError(withMessage: "Nothing to be searched", tag: 1)
            }else{
                SVProgressHUD.show()
                let search = searchTextView.text!
                
                searchTextView.text = ""
                searchTextView.isHidden = true
                searchTextView.isEnabled = false
                searchVisible = false
                searchFor(search: search)
            }
        }
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        if searchVisible == false{
            indexPath.removeAll()
            tableView.reloadData()
        }
        searchTextView.isHidden = true
        searchTextView.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        searchVisible = false
        
    }
    
    private func searchFor(search:String){
        for i in 0..<purpose.count{
            if search == purpose[i]{
                print("reloading")
                indexPath.append(i)
            }
        }
        if indexPath.count > 0{
            tableView.reloadData()
        }else{
            showAlertForError(withMessage: "Search not found!", tag: 1)
            if searchVisible == false {
                cancelButton.isEnabled = false
                cancelButton.title = ""
                cancelButton.tintColor = UIColor.green
                indexPath.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    private func showAlertForError(withMessage message : String, tag: Int){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        var reEnter = UIAlertAction()
        if tag == 1{
            reEnter = UIAlertAction(title: "Retry", style: .cancel)
        }else{
            reEnter = UIAlertAction(title: "Retry", style: .default) { (action) in
                self.networking()
            }
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }

    
}
