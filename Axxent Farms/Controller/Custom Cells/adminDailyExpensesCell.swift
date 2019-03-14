//
//  adminDailyExpensesCell.swift
//  Farm
//
//  Created by Dhrubojyoti on 03/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminDailyExpensesCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var supplier: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var purpose: UILabel!
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
