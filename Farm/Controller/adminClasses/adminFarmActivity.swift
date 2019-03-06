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

    @IBOutlet weak var addButton: UIBarButtonItem!
    var descriptions = [String]()
    var farmName = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = false
        let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
        if type == 3 {
            addButton.tintColor = UIColor(white: 0.95, alpha: 1)
            addButton.isEnabled = false
        }
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
        for  i in 0...(json["addfarmactivity"].count - 1){
            self.farmName.append(json["addfarmactivity"][i]["activity_name"].string!)
            self.descriptions.append(json["addfarmactivity"][i]["activity_name"].string!)
            
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return farmName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminFarmActivityCell", for: indexPath) as! adminFarmActivityCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.farmDescription.text = "Description: \(descriptions[indexPath.row])"
        cell.name.text = "Name: \(farmName[indexPath.row])"
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
    
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }

}
