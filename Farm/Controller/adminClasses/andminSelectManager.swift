//
//  andminSelectManager.swift
//  Farm
//
//  Created by Dhrubojyoti on 04/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

protocol selectedData {
    func getData(name:String,id:String)
}

class andminSelectManager: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tag = ""
    var delegate:selectedData?
    var managerName = [String]()
    var managerId = [String]()
    var farmName = [String]()
    var farmId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        networking()
        if tag == "1"{
            navigationItem.title! = "Select Manager"
        }else{
            navigationItem.title! = "Select Farm"
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectManagerCell", for: indexPath) as! adminSelectManagerCell
        if tag == "1"{
            cell.managerName.text = managerName[indexPath.row]
        }
        else{
            cell.managerName.text! = farmName[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == "1"{
            return managerName.count
        }else{
            return farmName.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tag == "1"{
            delegate?.getData(name: managerName[indexPath.row], id: managerId[indexPath.row])
        }else{
            delegate?.getData(name: farmName[indexPath.row], id: farmId[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
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
        if tag == "1"{
            for  i in 0...(json["login_user"].count - 1){
                if(json["login_user"][i]["type"] == "2"){
                    managerName.append(json["login_user"][i]["name"].string!)
                    managerId.append(json["login_user"][i]["id"].string!)
                }
            }
        }else{
            for  i in 0...(json["add_f"].count - 1){
                farmName.append(json["add_f"][i]["farm_n"].string!)
                farmId.append(json["add_f"][i]["id"].string!)
            }
        }
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
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
    
    func getData(name:String,id:String){
    }

}
