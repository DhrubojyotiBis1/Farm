//
//  AddPlot.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AddPlot: UITableViewController,selectedData {
    func getData(name: String,id:String) {
        if tag == "1"{
            print(id)
            selectedManager = name
            selectedManagerId = id
            managerName.text! = selectedManager
        }else {
            print(id)
            selectedFarm = name
            selectedManagerId = id
            farmName.text! = selectedFarm
        }
    }
    

    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var farmName: UITextField!
    @IBOutlet weak var managerName: UITextField!
    var selectedManager = ""
    var selectedFarm = ""
    var selectedFarmId = ""
    var selectedManagerId = ""
    @IBOutlet weak var descriptions: UITextField!

    @IBOutlet weak var plotName: UITextField!
    @IBOutlet var fourthCoordinate: [UITextField]!
    @IBOutlet var thirdCoordinate: [UITextField]!
    @IBOutlet var secondCoordinate: [UITextField]!
    @IBOutlet var firstCoordinate: [UITextField]!
    var tag = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
    }

    @IBAction func doneButtinClicked(_ sender: Any) {
        print(selectedManager)
        print(selectedFarm)
        SVProgressHUD.show()
        var condition = true
        for i in 0..<2{
            if firstCoordinate[i].text! == ""{
                condition = false
                showAlertForError(withMessage: "First coordinate is empty!")
            }else if secondCoordinate[i].text! == ""{
                condition = false
                showAlertForError(withMessage: "Second coordinate is empty!")
            }else if thirdCoordinate[i].text! == ""{
                condition = false
                showAlertForError(withMessage: "Third coordinate is empty!")
            }else if fourthCoordinate[i].text! == ""{
                condition = true
                showAlertForError(withMessage: "Fourth coordinate is empty!")
            }else if plotName.text == ""{
                condition = false
                showAlertForError(withMessage: "Plot name is empty!")
            }else if descriptions.text! == "" {
                condition = false
                showAlertForError(withMessage: "Description is empty!")
            }else if farmName.text! == ""{
                condition = false
                showAlertForError(withMessage: "Farm name is empty!")
            }else if managerName.text! == ""{
                condition = false
                showAlertForError(withMessage: "Manager name is empty!")
            }else if size.text! == ""{
                condition = false
                showAlertForError(withMessage: "Plot size is empty!")
            }
        }
        
        if condition {
            networking()
        }
        print(fourthCoordinate[0].text!)
        print(fourthCoordinate[1].text!)
        
    }
    

    @IBAction func selectManagerButtonPressed(_ sender: Any) {
        tag = "1"
        performSegue(withIdentifier: "goToSelectManager", sender: nil)
    }
    
    @IBAction func selectFarmButtonPressed(_ sender: Any) {
        tag = "2"
        performSegue(withIdentifier: "goToSelectManager", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "goToSelectManager"{
            let destination = segue.destination as! andminSelectManager
            destination.tag = tag
            destination.delegate = self
        }
    }
    private func networking(){
        //TODO: Networking is done here :
        let url = Url()
        Alamofire.request(url.ADD_PLOT_URL, method: .post, parameters: ["loan_t":selectedFarmId,"loan_type":selectedManagerId,"farmdisc":descriptions.text!,"latone":firstCoordinate[0].text!,"longone":firstCoordinate[1].text!,"lattwo":secondCoordinate[0].text!,"longtwo":secondCoordinate[1].text!,"latthree":thirdCoordinate[0].text!,"longthree":thirdCoordinate[1].text!,"latfour":fourthCoordinate[0].text!,"longfour":fourthCoordinate[1].text!,"farmname":plotName.text!,"farmsize":size.text!]).responseString{
            response in
            if response.result.value!.count == 23{
                print(response.result.value!)
                self.showSuccess(withMessage: "New plot has been added")
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
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
    
}

