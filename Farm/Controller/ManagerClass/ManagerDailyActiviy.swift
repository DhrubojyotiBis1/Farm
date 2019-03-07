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
    
    func didClickedViewButton(cell: UITableViewCell) {
        totalImageUrl.removeAll()
        tatalImagesName.removeAll()
        flag = 1
        //        documentName.removeAll()
        //        videoName.removeAll()
        //        comment.removeAll()
        //        details.removeAll()
        //        areaCovered.removeAll()
        indexPathOfViewImage = (tableView.indexPath(for: cell)?.row)!
        networking()
        SVProgressHUD.show()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.tabBar.isHidden = false
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
        self.performSegue(withIdentifier: "goToWebView", sender: nil)
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
        self.performSegue(withIdentifier: "goToWebView", sender: nil)
    }
    
    var tag = 0
    var flag = 0
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
    var totalImageUrl = [String]()
    
    
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
        cell.name.text! = "Plot name: " + plotName[indexPath.row]
        cell.activity.text! = "Activity name: " + activityName[indexPath.row]
        cell.areaCovered.text! = "Area covered: " + areaCovered[indexPath.row]
        cell.comment.text! = "Comment: "+comment[indexPath.row]
        cell.descriptions.text! = "Description: "+details[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plotName.count
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
                self.showAlertForError(withMessage: "Check your internet connection")
            }
        }
    }
    
    private func dataParsing(json : JSON){
        var plotId = [String]()
        var activityId = [String]()
        var imageId = [String]()
        for  i in 0...(json["dailyactivity"].count - 1){
            imageId.append(json["dailyactivity"][i]["dactivity_id"].string!)
            documentName.append(json["dailyactivity"][i]["docname"].string!)
            videoName.append(json["dailyactivity"][i]["vidname"].string!)
            comment.append(json["dailyactivity"][i]["cmts"].string!)
            activityId.append(json["dailyactivity"][i]["actid"].string!)
            details.append(json["dailyactivity"][i]["det"].string!)
            plotId.append(json["dailyactivity"][i]["farmid"].string!)
            areaCovered.append(json["dailyactivity"][i]["hect"].string!)
        }
        getPlotNameAndActivityName(withPlotId: plotId, andActivityId: activityId, json: json)
        getTotalImages(json: json, totalId: imageId)
        print(plotName.count)
        if flag == 0{
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    private func getPlotNameAndActivityName(withPlotId:[String],andActivityId:[String],json:JSON){
        for i in 0..<(json["add_farm"].count){
            //TODO: finding plot name
            for j in 0..<(withPlotId.count){
                if json["add_farm"][i]["farm_id"].string! == withPlotId[j]{
                    plotName.append(json["add_farm"][i]["farm_name"].string!)
                }
                
            }
        }
        
        for i in 0..<(json["addfarmactivity"].count){
            //TODO: finding activity name
            for j in 0..<(andActivityId.count){
                if json["addfarmactivity"][i]["activity_id"].string! == andActivityId[j]{
                    activityName.append(json["addfarmactivity"][i]["activity_name"].string!)
                }
            }
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
    
    private func getTotalImages(json: JSON,totalId: [String]){
        
        for j in 0..<json["imgdoc"].count{
            if indexPathOfViewImage != nil{
                if totalId[indexPathOfViewImage!] == json["imgdoc"][j]["fileid"].string!{
                    print(totalId[indexPathOfViewImage!])
                    tatalImagesName.append(json["imgdoc"][j]["image_original"].string!)
                    tatalImagesId.append(json["imgdoc"][j]["id"].string!)
                }
            }
        }
        
        print(tatalImagesId)
        getUrl(totalImageId: tatalImagesId, Json: json)
    }
    
    
    private func getUrl(totalImageId: [String],Json: JSON){
        let url = Url()
        for i in 0..<tatalImagesId.count {
            for j in 0..<Json["imgdoc"].count{
                if tatalImagesId[i] == Json["imgdoc"][j]["id"].string! {
                    print(tatalImagesId[i])
                    let downloadURL = url.DOWNLOAD_URL + Json["imgdoc"][j]["file"].string!
                    let downloadCompleteURL = downloadURL.replacingOccurrences(of: " ", with: "%20")
                    totalImageUrl.append(downloadCompleteURL)
                }
            }
        }
        
        print(totalImageUrl)
        if totalImageUrl.count != 0{
            performSegue(withIdentifier: "goToSelectImage", sender: nil)
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

