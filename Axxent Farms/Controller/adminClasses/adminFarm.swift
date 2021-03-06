//
//  adminFarm.swift
//  Farm
//
//  Created by Dhrubojyoti on 28/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import CoreLocation

class adminFarm: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var farmName = [String]()
    var farmSize = [String]()
    var descriptions = [String]()
    var location = [String]()
    var indexPath = [Int]()
    var searchVisible = false
    var flag = 0
    //TODO: DispatchGroup is used to wait untill the data is fetch back
    let dispatchGroup = DispatchGroup()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = false
        let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
        if type == 3 {
            addButton.tintColor = UIColor(white: 0.95, alpha: 1)
            addButton.isEnabled = false
        }
        let svProgressHudCheck = checkForSVProgressHUD()
        svProgressHudCheck.checkForSVProgressHUD(withFlag: flag)
        
        searchTextField.isHidden = true
        searchTextField.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        indexPath.removeAll()
        tableView.reloadData()

    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        networking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        indexPath.removeAll()
        if farmName.count > 0{
            if searchVisible == false{
                searchTextField.isHidden = false
                searchTextField.isEnabled = true
                searchVisible = true
                print("Entered")
                cancelButton.isEnabled = true
                cancelButton.title = "Cancel"
                cancelButton.tintColor = UIColor.darkGray
            }else{
                //according to the search reload the table view
                
                if searchTextField.text! == ""{
                    showAlertForError(withMessage: "Nothing to be searched", tag: 1)
                }else{
                    SVProgressHUD.show()
                    let search = searchTextField.text!
                    
                    searchTextField.text = ""
                    searchTextField.isHidden = true
                    searchTextField.isEnabled = false
                    //                cancelButton.isEnabled = false
                    //                cancelButton.title = ""
                    //                cancelButton.tintColor = UIColor.green
                    searchVisible = false
                    searchFor(search: search)
                }
            }
        }else{
            showAlertForError(withMessage: "Please wait!", tag: 1)
        }
        
        
    }
    
    @IBAction func cancelButtonPreesed(_ sender: Any) {
        if searchVisible == false{
            indexPath.removeAll()
            tableView.reloadData()
        }
        searchTextField.isHidden = true
        searchTextField.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        searchVisible = false
        
        
    }
    
    
    private func searchFor(search:String){
        for i in 0..<farmName.count{
            if search == farmName[i]{
                print("reloading")
                indexPath.append(i)
            }
        }
        if indexPath.count > 0{
            tableView.reloadData()
        }else{
            showAlertForError(withMessage: "Search not found!", tag: 1)
            if searchVisible == false {
                cancelButton.isEnabled = false
                cancelButton.title = ""
                cancelButton.tintColor = UIColor.green
                indexPath.removeAll()
                tableView.reloadData()
            }
        }
    }
    
    private func networking(){
        //TODO: Networking is done here :
        SVProgressHUD.show()
        let url = Url()
        Alamofire.request(url.dataUrl).responseJSON { (response) in
            if response.result.isSuccess{
                let userjson:JSON = JSON(response.result.value!)
                self.dataParsing(json: userjson)
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection", tag: 0)
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: sender)
    }
    private func dataParsing(json : JSON){
        for  i in 0...(json["add_f"].count - 1){
            farmName.append(json["add_f"][i]["farm_n"].string!)
            farmSize.append(json["add_f"][i]["farm_s"].string!)
            descriptions.append(json["add_f"][i]["farm_d"].string!)
            let latitude = json["add_f"][i]["farmla"].string!
            let longitude = json["add_f"][i]["farmlo"].string!
            self.getAddressFromLatLon(pdblLatitude:latitude , withLongitude: longitude)
        }
        dispatchGroup.notify(queue: .main) {
            //TODO: run only when the dispatch group does not have anything
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            self.flag = 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if indexPath.count > 0 {
            return indexPath.count
        }else{
            return farmName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "auditorFarmCell", for: indexPath) as! adminFarmCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
         SVProgressHUD.dismiss()
        if self.indexPath.count > 0{
            cell.name.text = "Fram Name: "+farmName[self.indexPath[indexPath.row]]
            cell.farmSize.text = "Farmsize: "+farmSize[self.indexPath[indexPath.row]]
            cell.descriptions.text = "Description: " + descriptions[self.indexPath[indexPath.row]]
            if location.isEmpty == false {
                cell.location.text = "Location: " + location[self.indexPath[indexPath.row]]
            }
            return cell
            
        }else{
            
            cell.name.text = "Fram Name: "+farmName[indexPath.row]
            cell.farmSize.text = "Farmsize: "+farmSize[indexPath.row]
            cell.descriptions.text = "Description: " + descriptions[indexPath.row]
            if location.isEmpty == false {
                cell.location.text = "Location: " + location[indexPath.row]
            }
            return cell
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

    private func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    private func showAlertForError(withMessage message : String,tag: Int){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        var reEnter = UIAlertAction()
        if tag == 1{
            reEnter = UIAlertAction(title: "Retry", style: .cancel)
        }else{
            reEnter = UIAlertAction(title: "Retry", style: .default) { (action) in
                self.networking()
            }
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }

}
