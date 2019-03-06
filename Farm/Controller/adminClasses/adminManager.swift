//
//  Home.swift
//  Farm
//
//  Created by Dhrubojyoti on 09/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class adminManager: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var name = [String]()
    var userName = [String]()
    var email = [String]()
    var managerId = [String]()
    var contactNumber = [String]()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.allowsSelection = false
        networking()
    }
    override func viewWillAppear(_ animated: Bool) {
        //TODO: removes the back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: nil)
        self.tabBarController!.tabBar.isHidden = false
        let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
        if type == 3 {
            addButton.tintColor = UIColor(white: 0.95, alpha: 1)
            addButton.isEnabled = false
        }

    }

    @IBAction func logOutButtonclicked(_ sender: UIButton) {
        //TODO: takes the user to the login page when logout button is clicked
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "type")
        dismiss(animated: true, completion: nil)
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
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    
    private func dataParsing(json : JSON){
        for  i in 0...(json["login_user"].count - 1){
            if(json["login_user"][i]["type"] == "2"){
                name.append(json["login_user"][i]["name"].string!)
                userName.append(json["login_user"][i]["username"].string!)
                managerId.append(json["login_user"][i]["id"].string!)
                email.append(json["login_user"][i]["email"].string!)
                contactNumber.append(json["login_user"][i]["phone"].string!)
            }
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "createAccount", sender: sender)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "adminManagerCell", for: indexPath) as! adminManagerCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.name.text = name[indexPath.row]
        cell.userName.text = "Username: \(userName[indexPath.row])"
        cell.email.text = "Email: \(email[indexPath.row])"
        cell.managerId.text = "Manager Id: \(managerId[indexPath.row])"
        cell.contact.text = "Contact: \(contactNumber[indexPath.row])"
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createAccount"{
            let createAccount = segue.destination as! CreateAccount
            createAccount.type = "2"
        }
    }
    
}
