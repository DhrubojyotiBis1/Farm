//
//  Addfarm.swift
//  Farm
//
//  Created by Dhrubojyoti on 02/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class Addfarm: UITableViewController {
    
    @IBOutlet var longitude: [UITextField]!
    @IBOutlet var latitude: [UITextField]!
    @IBOutlet weak var descriptions: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var farmName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController!.tabBar.isHidden = true
        SVProgressHUD.dismiss()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        if farmName.text! == "" || descriptions.text! == "" || size.text! == "" || longitude[0].text! == "" || latitude[0].text! == ""{
            if farmName.text! == "" {
                showAlertForError(withMessage: "Farm name is empty")
            }else if descriptions.text! == ""{
                showAlertForError(withMessage: "Description is empty")
            }else if size.text! == ""{
                showAlertForError(withMessage: "Size is empty")
            }else if longitude[0].text! == ""{
                showAlertForError(withMessage: "Longitude 1 is empty")
            }else{
                showAlertForError(withMessage: "Latitude 1 is empty")
            }
        }else{
            networking()
        }
    }
    
    private func networking(){
        //TODO: Networking is done here :
        let url = Url()
        
        Alamofire.request(url.ADD_FARM_URL,method: .post , parameters : ["farmname" : farmName.text!,"farmsize" : size.text!,"farmdisc" : descriptions.text! , "farmlat" : latitude[0].text! , "farmlong" : longitude[0].text! ,"farmlong2" : longitude[1].text! , "farmlong3" : longitude[2].text! , "farmlong4":longitude[3].text!, "farmlong5":longitude[4].text!, "farmlong6":longitude[5].text!, "farmlong7":longitude[6].text!, "farmlong8":longitude[7].text!, "farmlong9":longitude[8].text!, "farmlong10":longitude[9].text!, "farmlat2" : latitude[1].text!, "farmlat3" : latitude[2].text!, "farmlat4" : latitude[3].text!, "farmlat5" : latitude[4].text!, "farmlat6" : latitude[5].text!, "farmlat7" : latitude[6].text!, "farmlat8" : latitude[7].text!, "farmlat9" : latitude[8].text!, "farmlat10" : latitude[9].text!]).responseString{ (response) in
            if response.result.isSuccess{
              let userJSON : JSON = JSON(response.result.value!)
                print(userJSON)
                self.showSuccess(withMessage: "New Farm is added")
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Retry", style: .cancel)
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    private func showSuccess(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Thnak You", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            SVProgressHUD.dismiss()
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
}
