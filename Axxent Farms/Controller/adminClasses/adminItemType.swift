//
//  adminItemType.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
class adminItemType: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var name = [String]()
    var discriptions = [String]()
    var manufacturer = [String]()
    var indexPath = [Int]()
    var searchVisible = false
    var flag = 0
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        networking()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: removes the back button
        self.tabBarController!.tabBar.isHidden = false
        let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
        if type == 3 {
            addButton.tintColor = UIColor(white: 0.95, alpha: 1)
            addButton.isEnabled = false
        }
        let svProgressHudCheck = checkForSVProgressHUD()
        svProgressHudCheck.checkForSVProgressHUD(withFlag: flag)
        searchTextField.isHidden = true
        searchTextField.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        indexPath.removeAll()
        tableView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "goToAddItems", sender: sender)
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        indexPath.removeAll()
        if name.count > 0{
            if searchVisible == false{
                searchTextField.isHidden = false
                searchTextField.isEnabled = true
                searchVisible = true
                print("Entered")
                cancelButton.isEnabled = true
                cancelButton.title = "Cancel"
                cancelButton.tintColor = UIColor.darkGray
            }else{
                //according to the search reload the table view
                
                if searchTextField.text! == ""{
                    showAlertForError(withMessage: "Nothing to be searched", tag: 1)
                }else{
                    SVProgressHUD.show()
                    let search = searchTextField.text!
                    
                    searchTextField.text = ""
                    searchTextField.isHidden = true
                    searchTextField.isEnabled = false
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
        searchTextField.isHidden = true
        searchTextField.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        searchVisible = false
        
    }
    
    private func searchFor(search:String){
        for i in 0..<name.count{
            if search == name[i]{
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
        for  i in 0...(json["additem"].count - 1){
            manufacturer.append(json["additem"][i]["item_man"].string!)
            discriptions.append(json["additem"][i]["item_disc"].string!)
            name.append(json["additem"][i]["item_name"].string!)
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
        flag = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexPath.count > 0{
            return indexPath.count
        }else{
            return name.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminItemTypeCell", for: indexPath) as! adminItemTypeCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        SVProgressHUD.dismiss()
        if self.indexPath.count > 0{
            cell.name.text = "Name : " + name[self.indexPath[indexPath.row]]
            cell.manufacturer.text = "Manufacturer : " + manufacturer[self.indexPath[indexPath.row]]
            cell.discriptions.text = "Description : " + discriptions[self.indexPath[indexPath.row]]
            return cell
        }else{
            cell.name.text = "Name : " + name[indexPath.row]
            cell.manufacturer.text = "Manufacturer : " + manufacturer[indexPath.row]
            cell.discriptions.text = "Description : " + discriptions[indexPath.row]
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
    
    }


