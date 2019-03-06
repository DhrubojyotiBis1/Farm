//
//  selectImage.swift
//  Farm
//
//  Created by Dhrubojyoti on 06/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD

class selectImage: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var name = [String]()
    var urls = [String]()
    var selectedUrl = ""

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.dismiss()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        print(".....................")
        print(name)
        print(urls)
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectImageCell", for: indexPath) as! selectImangeCell
        cell.imageName.text = name[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUrl = urls[indexPath.row]
        SVProgressHUD.show()
        performSegue(withIdentifier: "goToWebView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWebView" {
            let destination = segue.destination as! webView
            destination.downloadUrl = selectedUrl
        }
    }
    
}
