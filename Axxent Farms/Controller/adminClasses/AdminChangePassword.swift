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
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        SVProgressHUD.show()
        if newPassword.text! == "" || oldPassword.text! == "" || confirmPassword.text! == "" {
            if newPassword.text! == ""{
                showAlertForError(withMessage: "Enter new password")
            }else if confirmPassword.text! == "" {
                showAlertForError(withMessage: "Enter confirm password")
            }else{
                showAlertForError(withMessage: "Enter old password")
            }
        }else{
            if newPassword.text! == confirmPassword.text!{
                networking()
            }else{
                showAlertForError(withMessage: "New password and confirm password does not match!")
            }
        }
    }
    
    private func networking(){
        //TODO: Networking is done here : user_id
        let id = String(describing: (UserDefaults.standard.value(forKey: "id"))!)
        let url = Url()
        print(id)
        Alamofire.request(url.CHANGE_PASSWORD, method: .post, parameters: ["chanpass": oldPassword.text!,"curpass":newPassword.text!,"concurpass":confirmPassword.text!,"user_id":id]).responseString{
            response in
            print(response.result.value!.count)
            print(response.result.value!)
            if response.result.isSuccess{
                if response.result.value!.count == 90{
                    self.showSuccess(withMessage: "Password has benn changed")
                }else{
                    self.showAlertForError(withMessage: "You Entered your old password Incorrectly!")
                }
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
            self.confirmPassword.text! = ""
            self.newPassword.text! = ""
            self.oldPassword.text! = ""
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
    
}
