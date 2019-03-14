//
//  SelectDate.swift
//  Farm
//
//  Created by Dhrubojyoti on 09/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
protocol dateDelegate{
    func getDate(date:String)
}

class SelectDate: UITableViewController {
    var date = ""
    var delegate : dateDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: #selector(dateChangedForAnyChange(_:)), for: .valueChanged)
    }
    
    @objc func dateChangedForAnyChange(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            date = "\(day) \(month) \(year)".replacingOccurrences(of: " ", with: "/")
            delegate?.getDate(date: date)
        }
        
        
    }

    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if date == ""{
            let components = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
            let day = components.day
            let month = components.month
            let year = components.year
            date = "\(day!) \(month!) \(year!)".replacingOccurrences(of: " ", with: "/")
            delegate?.getDate(date: date)
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    
}
