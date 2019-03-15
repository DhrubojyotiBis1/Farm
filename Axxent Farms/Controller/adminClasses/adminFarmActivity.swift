//
//  adminFarmActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 28/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class adminFarmActivity: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!    
    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var descriptions = [String]()
    var farmName = [String]()
    var indexPath = [Int]()
    var searchVisible = false
    var flag = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = false
        let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
        if type == 3 {
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

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.allowsSelection = false
        networking()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToAddActivity", sender: sender)
    }
 
    
    
    
    @IBAction func searchButtonPreesed(_ sender: Any) {
        indexPath.removeAll()
        if farmName.count > 0{
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
        }else{
            showAlertForError(withMessage: "Please wait!", tag: 1)
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
        for i in 0..<farmName.count{
            if search == farmName[i]{
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
        for  i in 0...(json["addfarmactivity"].count - 1){
            self.farmName.append(json["addfarmactivity"][i]["activity_name"].string!)
            self.descriptions.append(json["addfarmactivity"][i]["activity_disc"].string!)
            
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
        flag = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.indexPath.count > 0{
            return self.indexPath.count
        }else{
            return farmName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminFarmActivityCell", for: indexPath) as! adminFarmActivityCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        SVProgressHUD.dismiss()
        if self.indexPath.count > 0{
            print("Entered")
            cell.farmDescription.text = "Description: \(descriptions[self.indexPath[indexPath.row]])"
            cell.name.text = "Name: \(farmName[self.indexPath[indexPath.row]])"
            return cell
        }else{
            cell.farmDescription.text = "Description: \(descriptions[indexPath.row])"
            cell.name.text = "Name: \(farmName[indexPath.row])"
            return cell
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
    
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }

}
