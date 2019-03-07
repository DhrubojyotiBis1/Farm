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

    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var name = [String]()
    var discriptions = [String]()
    var manufacturer = [String]()
    

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
        
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "goToAddItems", sender: sender)
        
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
        for  i in 0...(json["additem"].count - 1){
            manufacturer.append(json["additem"][i]["item_man"].string!)
            discriptions.append(json["additem"][i]["item_disc"].string!)
            name.append(json["additem"][i]["item_name"].string!)
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminItemTypeCell", for: indexPath) as! adminItemTypeCell
        
        cell.name.text = "Name : " + name[indexPath.row]
        cell.manufacturer.text = "Manufacturer : " + manufacturer[indexPath.row]
        cell.discriptions.text = "Description : " + discriptions[indexPath.row]
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
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


