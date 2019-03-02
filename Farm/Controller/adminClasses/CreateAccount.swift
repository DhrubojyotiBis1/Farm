//
//  CreateAccount.swift
//  Farm
//
//  Created by Dhrubojyoti on 02/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class CreateAccount: UITableViewController {
    var type = ""
    @IBOutlet weak var userNane: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var managerId: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.tabBarController!.tabBar.isHidden = true
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        if userNane.text! == "" || phoneNumber.text! == "" || managerId.text! == "" || email.text! == "" || password.text! == "" || name.text! == ""{
             print("Error")
            if userNane.text! == "" {
                showAlertForError(withMessage: "Username is emply!")
            }else if phoneNumber.text! == ""{
                showAlertForError(withMessage: "Phone number is empty")
            }else if managerId.text! == "" {
                showAlertForError(withMessage: "Manager Id number is empty")
            }else if email.text! == "" {
                showAlertForError(withMessage: "Email Id number is empty")
            }else if password.text! == "" {
                showAlertForError(withMessage: "Password Id number is empty")
            }else{
                showAlertForError(withMessage: "Name Id number is empty")
            }
        }else{
            SVProgressHUD.show()
            networking(userName: userNane.text!, andPassword: password.text!, email: email.text!, managerId: managerId.text!, name: name.text!, phoneNumber: phoneNumber.text!)
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
    
    private func networking(userName : String , andPassword password :String,email : String , managerId : String ,name : String,phoneNumber : String){
        //TODO: Networking is done here :
        let url = URL()
        print(userName)
        print(name)
        print(email)
        print(phoneNumber)
        print(managerId)
        print(password)
        print(type)
//        Alamofire.request(url.CREATE_ACCOUNT_URL ,method: .put , parameters : ["email": email,"password" : password ,"type" : self.type , "username" : userName , "phone" : phoneNumber , "id" : managerId, "client_num" : "1" , "name" : name]).responseData { (response) in
//            print(response)
//            if response.result.isSuccess{
//                self.showSuccess(withMessage: "New Account has been created")
//            }else{
//                print("Error")
//                self.showAlertForError(withMessage: "Check your internet connection")
//            }
//        }
        

        
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
