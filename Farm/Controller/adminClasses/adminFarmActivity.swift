//
//  adminFarmActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 28/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class adminFarmActivity: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    let content = ["hdsgjhagdhagdhgajhgshgdhajsgdajhgdhagdhasghgdjhagsdgjhgajsdhsgdhjsgfhfghsdfghjsdgfhjgjhsdgfhgsdhgsjhgfhsjgfhjfgsjhghfgsjhghjsgdjhfghjdsgfhjgfshjdghjfghjdgsjhfgshdgjhdfgshjgfhjsgfjhgfhjsdghjdgshjgfhjdghjfgsj","jadhjkdhjashdhjsaghdjgajhdgahsjdgahjdghajghdgahjdgahgdajhgsdja","jdashdhajsdhjjahajdhjsdghjagshdgsfdhgafgsfdghsfdhgafsghfaghsfdghasfaghdfhasfhgdfsaghfdhgdfaghsfdhgfdghfasgfahsgfahgdfghdfshgdfahgsdfghafshgdfsahgdfagda","sdhjahjdhajsgdahjgdjhagsjh"]
    let name = ["sdfagsdfh","dsaghgsadgdfhsdjfgjhsdgjhjfhjshghgfhjsgfhsghdgjfgsjhdgfhjgsjfhgfsjhgfjhsgfshjfghfgshjfgshjghjfgj","dasjahjsgdahddasd","asdhshjdgadhjg"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureTableView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminFarmActivityCell", for: indexPath) as! adminFarmActivityCell
        cell.farmDescription.text = content[indexPath.row]
        cell.name.text = name[indexPath.row]
        
        return cell
    }
    
    func configureTableView(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }

}
