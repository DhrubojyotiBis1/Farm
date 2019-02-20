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
        goToHome()
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
                self.saveLoginData(username: self.userName.text!, password: self.password.text!,type: 0)
            }
        }
    }
    
    
    private func checkLoginStatus(json : JSON){
        //TODO: check wether the login is success or not :
        if(json["login_status"]==1){
            print(json)
            SVProgressHUD.dismiss()
            saveLoginData(username: userName.text!, password: password.text!, type: 0)
        }else{
           showAlertForError(withMessage: "Invalid username or password")
        }
    }
    
    
    private func goToHome(){
        //TODO: takes the user to home page:
        performSegue(withIdentifier: "goToAdmin", sender: nil)
    }
    private func saveLoginData(username: String,password:String,type: Int){
        //TODO: saves the login data User defoult i.e in a small database:
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(type, forKey: "type")
        
        
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
