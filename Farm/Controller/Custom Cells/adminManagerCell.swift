//
//  adminCell.swift
//  Farm
//
//  Created by Dhrubojyoti on 26/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminManagerCell: UITableViewCell {

    @IBOutlet weak var managerId: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var view: UIView!
    
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
