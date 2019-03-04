//
//  ViewController.swift
//  Farm
//
//  Created by Dhrubojyoti on 08/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import CoreData

class Login: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fixUI()
    }
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        checkLoginof(userName: userName.text!, andPassword: password.text!)
        SVProgressHUD.show()
    }
    

     private func checkLoginof(userName name : String , andPassword password :String){
        //TODO: Networking is done here :
        let url = URL()
        Alamofire.request(url.loginUrl ,method: .post , parameters : ["email": name,"password" : password]).responseJSON { (response) in
            if response.result.isSuccess{
                let userJSON : JSON = JSON(response.result.value!)
                self.checkLoginStatus(json: userJSON)
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    
    
    private func checkLoginStatus(json : JSON){
        //TODO: check wether the login is success or not :
        if(json["login_status"]==1){
            print(json)
            SVProgressHUD.dismiss()
            
            var type = 0
            if(json["type"] == "1"){
                type = 1
                goToHome(identifier: "goToAdmin")
            }else if(json["type"] == "2"){
                type = 2
                goToHome(identifier: "goToManager")
            }else{
                type = 3
                goToHome(identifier: "goToAdmin")
            }
            saveLoginData(username: userName.text!, password: password.text!, type:type , id: json["id"].string! )
        }else{
           showAlertForError(withMessage: "Invalid username or password")
        }
    }
    
    
    private func goToHome(identifier : String){
        //TODO: takes the user to home page:
        performSegue(withIdentifier: identifier, sender: nil)
    }
    private func saveLoginData(username: String,password:String,type: Int, id: String){
        //TODO: saves the login data User defoult i.e in a small database:
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(type, forKey: "type")
        UserDefaults.standard.set(id, forKey: "id")
        
    }
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Enter again", style: .cancel, handler: nil)
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    private func fixUI(){
        //TODO: for better ui experience:
        loginButton.layer.cornerRadius = 5
    
    }
}

