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
    
    //MARK:- takes the user to home page if login is done previously:
    override func viewWillAppear(_ animated: Bool) {
        if(getLoginData()){
            self.view.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if(getLoginData()){
            goToHome()
        }
    }
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
    
    //MARK:-
    private func checkLoginof(userName name : String , andPassword password :String){
        //TODO: Networking is done here :
        let url="http://axxentfarms.com/farm/files/pages/app/login.php?"
        Alamofire.request(url ,method: .post , parameters : ["email": name,"password" : password]).responseJSON { (response) in
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
            saveLoginData(username: userName.text!, password: password.text!)
            goToHome()
        }else{
           showAlertForError(withMessage: "Invalid username or password")
        }
    }
    
    
    private func goToHome(){
        //TODO: takes the user to home page:
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
    private func saveLoginData(username: String,password:String){
        //TODO: saves the login data to local database for future:
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let userData = NSEntityDescription.insertNewObject(forEntityName: "LoginData", into: context)
        
        userData.setValue(username, forKey: "username")
        userData.setValue(password, forKey: "password")
        
        do{
            try context.save()
            
        }catch{
            print("Error while saving data!")
        }
        
    }
    
    private func getLoginData()->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginData")
        request.returnsObjectsAsFaults = false
        do{
            let results = try context.fetch(request)
            if(results.count>0){
                return true
            }
        }catch{
            print("Error while getting data!")
        }
        
        return false
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

