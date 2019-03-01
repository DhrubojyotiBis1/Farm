//
//  auditorPlotCell.swift
//  Farm
//
//  Created by Dhrubojyoti on 02/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminPlotCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var manager: UILabel!
    @IBOutlet weak var plotSize: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var farmName: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.8
    }

}
