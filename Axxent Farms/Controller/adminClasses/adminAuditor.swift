//  adminAuditor.swift
//  Farm
//
//  Created by Dhrubojyoti on 28/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class adminAuditor: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var cancelButtonPressed: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var name = [String]()
    var flag = 0
    var searchVisible = false
    var userName = [String]()
    var email = [String]()
    var indexPath = [Int]()
    var managerId = [String]()
    var contactNumber = [String]()
    override func viewWillAppear(_ animated: Bool) {
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
        cancelButtonPressed.isEnabled = false
        cancelButtonPressed.title = ""
        cancelButtonPressed.tintColor = UIColor.green
        indexPath.removeAll()
        tableView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        networking()
    }
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
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
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "createAccount", sender: sender)
    }
    
    private func dataParsing(json : JSON){
        for  i in 0...(json["login_user"].count - 1){
            if(json["login_user"][i]["type"] == "3"){
                name.append(json["login_user"][i]["name"].string!)
                userName.append(json["login_user"][i]["username"].string!)
                managerId.append(json["login_user"][i]["id"].string!)
                email.append(json["login_user"][i]["email"].string!)
                contactNumber.append(json["login_user"][i]["phone"].string!)
            }
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
        flag = 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexPath.count > 0 {
            return indexPath.count
        }else{
            return name.count
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        indexPath.removeAll()
        if searchVisible == false{
            searchTextField.isHidden = false
            searchTextField.isEnabled = true
            searchVisible = true
            print("Entered")
            cancelButtonPressed.isEnabled = true
            cancelButtonPressed.title = "Cancel"
            cancelButtonPressed.tintColor = UIColor.darkGray
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
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        if searchVisible == false{
            indexPath.removeAll()
            tableView.reloadData()
        }
        searchTextField.isHidden = true
        searchTextField.isEnabled = false
        cancelButtonPressed.isEnabled = false
        cancelButtonPressed.title = ""
        cancelButtonPressed.tintColor = UIColor.green
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
                            cancelButtonPressed.isEnabled = false
                            cancelButtonPressed.title = ""
                            cancelButtonPressed.tintColor = UIColor.green
                indexPath.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "adminAuditorCell", for: indexPath) as! adminAuditorCell
        SVProgressHUD.dismiss()
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        if (self.indexPath.count > 0){
            cell.name.text = name[self.indexPath[indexPath.row]]
            cell.userName.text = "Username: \(userName[self.indexPath[indexPath.row]])"
            cell.email.text = "Email: \(email[self.indexPath[indexPath.row]])"
            cell.managerId.text = "Manager Id: \(managerId[self.indexPath[indexPath.row]])"
            cell.contactNumber.text = "Contact: \(contactNumber[self.indexPath[indexPath.row]])"
            return cell
        }else{
            cell.name.text = name[indexPath.row]
            cell.userName.text = "Username: \(userName[indexPath.row])"
            cell.email.text = "Email: \(email[indexPath.row])"
            cell.managerId.text = "Manager Id: \(managerId[indexPath.row])"
            cell.contactNumber.text = "Contact: \(contactNumber[indexPath.row])"
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createAccount"{
            let createAccount = segue.destination as! CreateAccount
            createAccount.type = "3"
        }
    }

}
