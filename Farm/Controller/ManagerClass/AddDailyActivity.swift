//
//  AddDailyActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 08/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class AddDailyActivity: UITableViewController,ManagerPlotSelected,dateDelegate {
    func getActivityIdAndName(name: String, id: String) {
        self.activitySelected.text = name
        self.selectedActivityId = id
    }
    
    func getDate(date: String) {
        self.date = date
        self.selectedDate.text! = date
    }

    var selectedActivityId = ""
    @IBOutlet weak var activitySelected: UITextField!
    var conditionToGoToSelectPlot:Int?
    @IBOutlet weak var comment: UITextField!
    @IBOutlet weak var details: UITextField!
    @IBOutlet weak var areaCovered: UITextField!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var imageName: UILabel!
    
    @IBOutlet weak var selectedPlot: UITextField!
    
    func getPlotIdAndNameSelected(name: String, id: String) {
        selectedPlot.text! = name
        plotId = id
    }

    
    @IBOutlet var addTableView: UITableView!
    var plotId = ""
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView.allowsSelection = false
    }


    @IBAction func selectPlot(_ sender: Any) {
        conditionToGoToSelectPlot = 1
      performSegue(withIdentifier: "goToSelectPlot", sender: sender)
    }
    
    @IBOutlet weak var selectedDate: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectPlot"{
            let destination = segue.destination as! ManagerSelectPlot
            destination.delegate = self
            if conditionToGoToSelectPlot! == 1{
                destination.tag = 1
            }else if conditionToGoToSelectPlot == 2{
                destination.tag = 2
            }
        }else if segue.identifier == "goToSelectDate"{
            let destination = segue.destination as! SelectDate
            destination.delegate = self
        }
    }
    
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        print("pressed")
        conditionToGoToSelectPlot = 2
        performSegue(withIdentifier: "goToSelectDate", sender: sender)
    }
    
    
    @IBAction func imageChooseButtonPressed(_ sender: Any) {
    }
    
    @IBAction func documentChooseButtonPressed(_ sender: Any) {
    }
    
    @IBAction func videoChooseButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func selectActivityButtonPressed(_ sender: Any) {
        conditionToGoToSelectPlot = 2
        performSegue(withIdentifier: "goToSelectPlot", sender: sender)
    }
}
