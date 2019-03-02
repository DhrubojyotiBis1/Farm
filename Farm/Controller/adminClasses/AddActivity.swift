//
//  AddActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class AddActivity: UIViewController {

    @IBOutlet weak var descriptions: UITextField!
    @IBOutlet weak var activityName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        SVProgressHUD.show()
        if descriptions.text! == "" || activityName.text! == ""{
            print("error")
            if descriptions.text! == ""{
                showAlertForError(withMessage: "Description is empty")
            }else{
                showAlertForError(withMessage: "Activity name is empty")
            }
        }else{
            networking()
        }
    }
    
    private func networking(){
        //TODO: Networking is done here :
        let url = URL()
        Alamofire.request(url.ADD_FARM_ACTIVITY_URL, method: .post, parameters: ["activity_name" : activityName.text!,"activity_disc" : descriptions.text!],encoding:
            JSONEncoding.default, headers: nil).validate(statusCode: 200..<300).responseData{
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
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
    

}
