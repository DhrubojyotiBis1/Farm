//
//  DailyActivityCell.swift
//  Farm
//
//  Created by Dhrubojyoti on 05/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

protocol cellDelegate {
    func didClickedViewButton(cell:UITableViewCell)
    func didClickedWatchButtonButton(cell:UITableViewCell)
    func didClickedViewDocumentButton(cell:UITableViewCell)
}

class ManagerDailyActivityCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    var delegate:cellDelegate?
    @IBOutlet weak var areaCovered: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var descriptions: UILabel!
    @IBOutlet weak var activity: UILabel!
    @IBOutlet weak var viewDocument: UIButton!
    @IBOutlet weak var watchVideo: UIButton!
    @IBOutlet weak var viewImage: UIButton!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewButtonPressed(_ sender: Any) {
        print("View Image Clicked")
        delegate?.didClickedViewButton(cell: self)
    }
    
    @IBAction func watchVideoButtonPressed(_ sender: Any) {
        print("Watch Video clicked")
        delegate?.didClickedWatchButtonButton(cell: self)
    }
    
    @IBAction func viewDocumentButtonPrseed(_ sender: Any) {
        print("View Document Clicked")
        delegate?.didClickedViewDocumentButton(cell: self)
    }
    
    override func layoutSubviews() {
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.8
        viewImage.layer.cornerRadius = 10
        viewDocument.layer.cornerRadius = 10
        watchVideo.layer.cornerRadius = 10
    }
}
