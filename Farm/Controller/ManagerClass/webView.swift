//
//  webView.swift
//  Farm
//
//  Created by Dhrubojyoti on 06/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD
class webView: UIViewController ,UIWebViewDelegate{
    
    var downloadUrl = ""

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.let url = URL(string: downloadUrl)
        webView.delegate = self
        self.tabBarController!.tabBar.isHidden = true
        loadData()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    private func loadData(){
        
        let url = URL(string: downloadUrl)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        SVProgressHUD.dismiss()
    }

}
