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
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
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
        let url = URL()
        
        Alamofire.request(url.ADD_FARM_URL,method: .post , parameters : ["id":"999","farm_n" : farmName.text!,"farm_s" : size.text!,"farm_d" : descriptions.text! , "farmla" : latitude[0].text! , "farmlo" : longitude[0].text! ,"farmlo2" : longitude[1].text! , "farmlo3" : longitude[2].text! , "farmlo4":longitude[3].text!, "farmlo5":longitude[4].text!, "farmlo6":longitude[5].text!, "farmlo7":longitude[6].text!, "farmlo8":longitude[7].text!, "farmlo9":longitude[8].text!, "farmlo10":longitude[9].text!, "farmla2" : latitude[1].text!, "farmla3" : latitude[2].text!, "farmla4" : latitude[3].text!, "farmla5" : latitude[4].text!, "farmla6" : latitude[5].text!, "farmla7" : latitude[6].text!, "farmla8" : latitude[7].text!, "farmla9" : latitude[8].text!, "farmla10" : latitude[9].text!]).responseData{ (response) in
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
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
}
