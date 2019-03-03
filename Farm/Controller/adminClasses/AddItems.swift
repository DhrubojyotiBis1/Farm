//
//  AddItems.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AddItems: UIViewController {

    @IBOutlet weak var itemManufacturer: UITextField!
    @IBOutlet weak var itemDescription: UITextField!
    @IBOutlet weak var itemName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        if itemName.text! == "" || itemDescription.text! == "" || itemManufacturer.text! == "" {
            if itemManufacturer.text! == ""{
                showAlertForError(withMessage: "No manufacturer entered")
            }else if itemDescription.text! == "" {
                showAlertForError(withMessage: "No description entered")
            }else{
                showAlertForError(withMessage: "No name entered")
            }
        }else{
            networking()
        }
        
    }
    
    
    private func networking(){
        //TODO: Networking here:
        let url = URL()
        Alamofire.request(url.ADD_ITEM_TYPE_URL,method: .post,parameters:["itemname":itemName.text! ,"itemdisc":itemDescription.text!,"itemman":itemManufacturer.text!]).responseString{responce in
            print(responce)
            if responce.result.isSuccess{
                self.showSuccess(withMessage: "New Account has been created")
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection!")
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
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
}
