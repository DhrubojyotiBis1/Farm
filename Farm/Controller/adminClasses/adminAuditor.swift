//
//  adminAuditor.swift
//  Farm
//
//  Created by Dhrubojyoti on 28/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class adminAuditor: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var name = [String]()
    var userName = [String]()
    var email = [String]()
    var managerId = [String]()
    var contactNumber = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        networking()
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "adminAuditorCell", for: indexPath) as! adminAuditorCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.name.text = name[indexPath.row]
        cell.userName.text = "Username: \(userName[indexPath.row])"
        cell.email.text = "Email: \(email[indexPath.row])"
        cell.managerId.text = "Manager Id: \(managerId[indexPath.row])"
        cell.contactNumber.text = "Contact: \(contactNumber[indexPath.row])"
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
    
    
}
