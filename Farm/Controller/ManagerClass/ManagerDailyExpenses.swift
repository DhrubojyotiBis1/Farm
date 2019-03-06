//
//  ManagerDailyActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 04/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ManagerDailyExpenses: UITableViewController,ManagerPlotSelected {
    func getPlotIdAndNameSelected(name: String, id: String) {
        selectedPlot.text! =  name
        plotId = id
    }
        var plotId = ""

    @IBOutlet weak var selectedPlot: UITextField!
    @IBOutlet weak var purposes: UITextField!
    @IBOutlet weak var supplierName: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    @IBOutlet weak var unitPrice: UITextField!
    @IBOutlet weak var unit: UITextField!
    @IBOutlet weak var descriptions: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func doneButtonPessed(_ sender: Any) {
        SVProgressHUD.show()
        print(plotId)
        if plotId == "" || purposes.text! == "" || supplierName.text! == "" || totalAmount.text! == "" || unitPrice.text! == "" || unit.text! == "" || descriptions.text! == ""{
            if plotId == "" {
                showAlertForError(withMessage: "Plot is not selected")
            }else if purposes.text! == "" {
                showAlertForError(withMessage: "Purposes is empty")
                
            }else if supplierName.text! == "" {
                showAlertForError(withMessage: "Supplier name is empty")
            }else if totalAmount.text! == "" {
                showAlertForError(withMessage: "Total amount is empty")
            }else if unitPrice.text! == "" {
                showAlertForError(withMessage: "Unit price is empty")
            }else if unit.text! == "" {
                showAlertForError(withMessage: "Unit is empty")
            }else if descriptions.text! == "" {
                showAlertForError(withMessage: "Description is empty")
            }
        }else{
            networking()
        }
    }
    
    
    
    private func networking(){
        //TODO: Networking is done here :
        let url = Url()
        Alamofire.request(url.ADD_DAILY_EXPENSE, method: .post, parameters: ["purpose": purposes.text! , "sname" : supplierName.text!,"description" : descriptions.text!,"unit" : unit.text!, "uprice":unitPrice.text!,"total":totalAmount.text!,"loan_type":plotId]).responseString{
            response in
            if response.result.value!.count == 33{
                self.showSuccess(withMessage: "Daily Expenses has been added")
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    
    
    @IBAction func selectPlot(_ sender: Any) {
        
        performSegue(withIdentifier: "goToSelectPlot", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectPlot"{
            let destination = segue.destination as! ManagerSelectPlot
            destination.delegate = self
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
    
    /*
     param.put("purpose", purpose);
     param.put("sname", supplier);
     param.put("description", description);
     param.put("unit", unit);
     param.put("uprice", unitPrice);
     param.put("total", total);
     param.put("loan_type", plotId);
     */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
