//
//  adminPlot.swift
//  Farm
//
//  Created by Dhrubojyoti on 02/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD
import CoreLocation

class adminPlot: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var farmName = [String]()
    var farmSize = [String]()
    var descriptions = [String]()
    var location = [String]()
    var plotName = [String]()
    var managerName = [String]()
    var realManagerId = [String]()
    var managerId = [String]()
    let dispatchGroup = DispatchGroup()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        networking()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plotName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminPlotCell", for: indexPath) as! adminPlotCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.name.text = "Plot Name: "+plotName[indexPath.row]
        cell.plotSize.text = "Farmsize: "+farmSize[indexPath.row]
        cell.descriptions.text = "Description: " + descriptions[indexPath.row]
        if location.isEmpty == false {
            cell.location.text = "Location: " + location[indexPath.row]
            
            for i in 0..<realManagerId.count{
                if managerId[indexPath.row] == realManagerId[i]{
                    cell.manager.text = "Manager: " + managerName[i]
                }
            }
        }
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: sender)
    }
    
    private func networking(){
        //TODO: Networking is done here :
        SVProgressHUD.show()
        let url = URL()
        Alamofire.request(url.dataUrl).responseJSON { (response) in
            if response.result.isSuccess{
                let userjson:JSON = JSON(response.result.value!)
                self.dataParsing(json: userjson)
                self.getManagerData(json: userjson)
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    private func dataParsing(json : JSON){
        for  i in 0...(json["add_farm"].count - 1){
            plotName.append(json["add_farm"][i]["farm_name"].string!)
            farmSize.append(json["add_farm"][i]["farm_size"].string!)
            descriptions.append(json["add_farm"][i]["farm_disc"].string!)
            managerId.append(json["add_farm"][i]["farm_manager"].string!)
            let latitude = json["add_farm"][i]["farmlat"].string!
            let longitude = json["add_farm"][i]["farmlong"].string!
            self.getAddressFromLatLon(pdblLatitude:latitude , withLongitude: longitude)
        }
        dispatchGroup.notify(queue: .main) {
            //TODO: run only when the dispatch group does not have anything
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    private func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        if ((Double("\(pdblLatitude)") != nil) && (Double("\(pdblLongitude)") != nil)){
            
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            var addressString : String = ""
            dispatchGroup.enter()//TODO: start's waiting for data here:
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        print(addressString)
                    }
                    self.dispatchGroup.leave()//TODO: stop's waiting
                    
                    print("inside")
            })
            dispatchGroup.notify(queue: .main) {
                //TODO: run only when the dispatch group does not have anything
                print("outside")
                if addressString == "" {
                    self.location.append("Error!")
                }else{
                    self.location.append(addressString)
                }
            }
        }else{
            location.append("Error!")
        }
        
    }
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.networking()
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    private func getManagerData(json : JSON){
        for  i in 0...(json["login_user"].count - 1){
            if(json["login_user"][i]["type"] == "2"){
                realManagerId.append(json["login_user"][i]["id"].string!)
                managerName.append(json["login_user"][i]["name"].string!)
            }
        }
    }
}
