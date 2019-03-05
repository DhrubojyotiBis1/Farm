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
        indexPathOfViewImage = (tableView.indexPath(for: cell)?.row)!
        print(indexPathOfViewImage)
    }
    
    func didClickedWatchButtonButton(cell: UITableViewCell) {
        indexPathOfWatchVideo = (tableView.indexPath(for: cell)?.row)!
        print(indexPathOfWatchVideo)
    }
    
    func didClickedViewDocumentButton(cell: UITableViewCell) {
        indexPathOfViewDocument = (tableView.indexPath(for: cell)?.row)!
        print(indexPathOfViewDocument)
    }
    var indexPathOfViewDocument = 0
    var indexPathOfViewImage = 0
    var indexPathOfWatchVideo = 0
    @IBOutlet weak var tableView: UITableView!
    var imageName = [String]()
    var documentName = [String]()
    var videoName = [String]()
    var details = [String]()
    var comment = [String]()
    var areaCovered = [String]()
    var activityName = [String]()
    var plotName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
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
        var plotId = [String]()
        var activityId = [String]()
        for  i in 0...(json["dailyactivity"].count - 1){
            imageName.append(json["dailyactivity"][i]["imgname"].string!)
            documentName.append(json["dailyactivity"][i]["imgname"].string!)
            videoName.append(json["dailyactivity"][i]["vidname"].string!)
            comment.append(json["dailyactivity"][i]["cmts"].string!)
            activityId.append(json["dailyactivity"][i]["actid"].string!)
            details.append(json["dailyactivity"][i]["det"].string!)
            plotId.append(json["dailyactivity"][i]["farmid"].string!)
            areaCovered.append(json["dailyactivity"][i]["hect"].string!)
        }
        getPlotNameAndActivityName(withPlotId: plotId, andActivityId: activityId, json: json)
        print(plotName.count)
        self.tableView.reloadData()
        SVProgressHUD.dismiss()
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


}
