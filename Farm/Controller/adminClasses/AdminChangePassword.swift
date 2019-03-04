//
//  AminChangePassword.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AdminChangePassword: UIViewController {
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        SVProgressHUD.show()
        if newPassword.text! == "" || oldPassword.text! == "" || confirmPassword.text! == "" {
            if newPassword.text! == ""{
                showSuccess(withMessage: "Enter new password")
            }else if confirmPassword.text! == "" {
                showAlertForError(withMessage: "Enter confirm password")
            }else{
                showAlertForError(withMessage: "Enter old password")
            }
        }else{
            networking()
        }
    }
    
    private func networking(){
        //TODO: Networking is done here : user_id
        let id = String(describing: (UserDefaults.standard.value(forKey: "id"))!)
        let url = URL()
        print(id)
        Alamofire.request(url.CHANGE_PASSWORD, method: .post, parameters: ["chanpass": oldPassword.text!,"curpass":newPassword.text!,"concurpass":confirmPassword.text!,"user_id":id]).responseString{
            response in
            print(response)
            if response.result.isSuccess{
                print(response.result.value!)
                self.showSuccess(withMessage: "New activity is added")
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
