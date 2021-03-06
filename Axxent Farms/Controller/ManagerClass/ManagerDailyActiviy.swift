//
//  ManagerDailyActiviy.swift
//  Farm
//
//  Created by Dhrubojyoti on 05/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class ManagerDailyActiviy: UIViewController,UITableViewDelegate,UITableViewDataSource,cellDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    var tag = 0
    var flag = 0
    var condition = 0
    var filePath = ""
    var indexpath:Int?
    var indexPathOfViewImage:Int?
    var tatalImagesName = [String]()
    var tatalImagesId = [String]()
    @IBOutlet weak var tableView: UITableView!
    var documentName = [String]()
    var videoName = [String]()
    var details = [String]()
    var comment = [String]()
    var areaCovered = [String]()
    var activityName = [String]()
    var plotName = [String]()
    var indexPath = [Int]()
    var totalImageUrl = [String]()
    var searchVisible = false
    
    
    func didClickedViewButton(cell: UITableViewCell) {
        totalImageUrl.removeAll()
        tatalImagesName.removeAll()
        flag = 1
                activityName.removeAll()
                plotName.removeAll()
                documentName.removeAll()
                videoName.removeAll()
                comment.removeAll()
                details.removeAll()
                areaCovered.removeAll()
        indexPathOfViewImage = (tableView.indexPath(for: cell)?.row)!
        networking()
        SVProgressHUD.show()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = false
        let svProgressHudCheck = checkForSVProgressHUD()
        svProgressHudCheck.checkForSVProgressHUD(withFlag: condition)
        searchTextField.isHidden = true
        searchTextField.isEnabled = false
        cancelButton.isEnabled = false
        cancelButton.title = ""
        cancelButton.tintColor = UIColor.green
        indexPath.removeAll()
        tableView.reloadData()

    }
    
    func didClickedWatchButtonButton(cell: UITableViewCell) {
        let url = Url()
        indexpath = (tableView.indexPath(for: cell)?.row)!
        let downloadURL = url.DOWNLOAD_URL + videoName[(tableView.indexPath(for: cell)?.row)!]
        let downloadCompleteURL = downloadURL.replacingOccurrences(of: " ", with: "%20")
        filePath = downloadCompleteURL
        downloadFile(url: downloadCompleteURL, name: "video\((tableView.indexPath(for: cell)?.row)!).mp4")
        tag = 2
        SVProgressHUD.show()
        
        if videoName[(tableView.indexPath(for: cell)?.row)!] != "" {
            self.performSegue(withIdentifier: "goToWebView", sender: nil)
        }else{
            showAlertForError(withMessage: "No video exist!", tag: 1)
        }
        
    }
    
    func didClickedViewDocumentButton(cell: UITableViewCell) {
        indexpath = (tableView.indexPath(for: cell)?.row)!
        let url = Url()
        let downloadURL = url.DOWNLOAD_URL + documentName[(tableView.indexPath(for: cell)?.row)!]
        let downloadCompleteURL = downloadURL.replacingOccurrences(of: " ", with: "%20")
        filePath = downloadCompleteURL
        downloadFile(url: downloadCompleteURL, name: "document\((tableView.indexPath(for: cell)?.row)!).pdf")
        tag = 1
        SVProgressHUD.show()
        if documentName[(tableView.indexPath(for: cell)?.row)!] != "" {
            self.performSegue(withIdentifier: "goToWebView", sender: nil)
        }else{
            showAlertForError(withMessage: "No document exist!", tag: 1)
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        networking()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyActivityCell", for: indexPath) as! ManagerDailyActivityCell
        cell.backgroundColor = UIColor(white: 0.95, alpha: 1)
        SVProgressHUD.dismiss()
        if self.indexPath.count > 0{
            cell.name.text! = "Plot name: " + plotName[self.indexPath[indexPath.row]]
            cell.activity.text! = "Activity name: " + activityName[self.indexPath[indexPath.row]]
            cell.areaCovered.text! = "Area covered: " + areaCovered[self.indexPath[indexPath.row]]
            cell.comment.text! = "Comment: "+comment[self.indexPath[indexPath.row]]
            cell.descriptions.text! = "Description: "+details[self.indexPath[indexPath.row]]
            cell.delegate = self
            return cell
        }else{
            cell.name.text! = "Plot name: " + plotName[indexPath.row]
            cell.activity.text! = "Activity name: " + activityName[indexPath.row]
            cell.areaCovered.text! = "Area covered: " + areaCovered[indexPath.row]
            cell.comment.text! = "Comment: "+comment[indexPath.row]
            cell.descriptions.text! = "Description: "+details[indexPath.row]
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.indexPath.count > 0{
            return indexPath.count
        }else{
            return areaCovered.count
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
                print("yes")
            }else{
                print("Error")
                self.showAlertForError(withMessage: "Check your internet connection", tag: 0)
            }
        }
    }
    
    private func dataParsing(json : JSON){
        var plotId = [String]()
        var activityId = [String]()
        var imageId = [String]()
        for  i in 0..<json["dailyactivity"].count {
            imageId.append(json["dailyactivity"][i]["dactivity_id"].string!)
            documentName.append(json["dailyactivity"][i]["docname"].string!)
            videoName.append(json["dailyactivity"][i]["vidname"].string!)
            comment.append(json["dailyactivity"][i]["cmts"].string!)
            activityId.append(json["dailyactivity"][i]["actid"].string!)
            details.append(json["dailyactivity"][i]["det"].string!)
            plotId.append(json["dailyactivity"][i]["farmid"].string!)
            areaCovered.append(json["dailyactivity"][i]["hect"].string!)
        }
        print(plotId.count)
        getPlotNameAndActivityName(withPlotId: plotId, andActivityId: activityId, json: json)
        getTotalImages(json: json, totalId: imageId)
        if flag == 0{
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            condition = 1
        }
    }
    
    private func getPlotNameAndActivityName(withPlotId:[String],andActivityId:[String],json:JSON){
        var count = 0
        for j in 0..<withPlotId.count{
            //TODO: finding plot name
            for i in 0..<(json["add_farm"].count){
                if withPlotId[j] == json["add_farm"][i]["farm_id"].string!{
                    count+=1
                    plotName.append(json["add_farm"][i]["farm_name"].string!)
                }
                
            }
        }
        
        for j in 0..<andActivityId.count{
            //TODO: finding activity name
            for i in 0..<(json["addfarmactivity"].count){
                if json["addfarmactivity"][i]["activity_id"].string! == andActivityId[j]{
                    activityName.append(json["addfarmactivity"][i]["activity_name"].string!)
                }
            }
        }
        
        print(plotName.count)
        print(comment.count)
        print(activityName.count)
        
    }
    
    private func showAlertForError(withMessage message : String, tag: Int){
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
    
    private func getTotalImages(json: JSON,totalId: [String]){
        
        for j in 0..<json["imgdoc"].count{
            if indexPathOfViewImage != nil{
                if totalId[indexPathOfViewImage!] == json["imgdoc"][j]["fileid"].string!{
                    tatalImagesName.append(json["imgdoc"][j]["image_original"].string!)
                    tatalImagesId.append(json["imgdoc"][j]["id"].string!)
                    print("yes")
                }
            }
        }
        
        getUrl(totalImageId: tatalImagesId, Json: json)
    }
    
    
    private func getUrl(totalImageId: [String],Json: JSON){
        let url = Url()
        for i in 0..<tatalImagesId.count {
            for j in 0..<Json["imgdoc"].count{
                if tatalImagesId[i] == Json["imgdoc"][j]["id"].string! {
                    let downloadURL = url.DOWNLOAD_URL + Json["imgdoc"][j]["file"].string!
                    let downloadCompleteURL = downloadURL.replacingOccurrences(of: " ", with: "%20")
                    totalImageUrl.append(downloadCompleteURL)
                }
            }
        }
        
        if flag != 0{
            if totalImageUrl.count != 0{
                performSegue(withIdentifier: "goToSelectImage", sender: nil)
            }else{
                showAlertForError(withMessage: "No image exist!", tag: 1)
            }
        }
        
    }
    
    func downloadFile(url:String,name:String){
        
        //        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        //            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //            documentsURL.appendPathComponent(name)
        //            return (documentsURL, [.removePreviousFile])
        //        }
        //
        //        print(url)
        //        Alamofire.download(url, to: destination).responseData { response in
        //
        //            if response.result.isSuccess{
        //                if let filePath = response.destinationURL?.path
        //                {
        //                    print(filePath)
        //                    self.filePath = filePath
        //                    self.performSegue(withIdentifier: "goToWebView", sender: nil)
        //                }
        //
        //            }else{
        //                //TODO: if not success
        //                self.showAlertForError(withMessage: "Something went wrong")
        //            }
        //        }
        
    }
    
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "type")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        SVProgressHUD.dismiss()
        performSegue(withIdentifier: "goToAddDailyActivity", sender: sender)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        indexPath.removeAll()
        if plotName.count > 0{
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
                    searchVisible = false
                    searchFor(search: search)
                }
            }
        }else{
           showAlertForError(withMessage: "Please wait!", tag: 1)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
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
        for i in 0..<plotName.count{
            if search == plotName[i]{
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "goToWebView" {
            let destination = segue.destination as! webView
            destination.downloadUrl = filePath
            destination.indexpath = indexpath!
            destination.tag = self.tag
        }else if segue.identifier! == "goToSelectImage"{
            let destination = segue.destination as! selectImage
            destination.name = tatalImagesName
            destination.urls = totalImageUrl
            destination.indexpath = indexPathOfViewImage!
        }
    }
    
}

