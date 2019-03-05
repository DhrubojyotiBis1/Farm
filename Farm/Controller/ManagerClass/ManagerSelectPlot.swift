//
//  ManagerSelectPlot.swift
//  Farm
//
//  Created by Dhrubojyoti on 04/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

protocol ManagerPlotSelected {
    func getPlotIdAndNameSelected(name:String , id:String)
}

class ManagerSelectPlot: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var plotName = [String]()
    var plotId = [String]()
    var delegate : ManagerPlotSelected?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        networking()
    }
    
    private func networking(){
        //TODO: Networking is done here :
        SVProgressHUD.show()
        let url = URL()
        Alamofire.request(url.dataUrl).responseJSON { (response) in
            if response.result.isSuccess{
                let userjson:JSON = JSON(response.result.value!)
                self.dataParsing(json: userjson)
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    private func dataParsing(json : JSON){
        for  i in 0...(json["add_farm"].count - 1){
            plotName.append(json["add_farm"][i]["farm_name"].string!)
            plotId.append(json["add_farm"][i]["farm_id"].string!)
        }

            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plotName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerSelectPoltCell", for: indexPath) as! ManagerSelectPlotCell
        
        cell.plotName.text = plotName[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getPlotIdAndNameSelected(name: plotName[indexPath.row], id: plotId[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Retry", style: .cancel)
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    func getPlotIdAndNameSelected(name:String , id:String){
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
