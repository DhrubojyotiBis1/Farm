//
//  webView.swift
//  Farm
//
//  Created by Dhrubojyoti on 06/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class webView: UIViewController ,UIWebViewDelegate{
    
   

    @IBOutlet weak var downloadButton: UIButton!
    var downloadUrl = ""
    var tag = 0
    var indexpath = 0

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.let url = URL(string: downloadUrl)
        SVProgressHUD.show()
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = UIView.ContentMode.scaleAspectFit
        self.tabBarController!.tabBar.isHidden = true
        downloadButton.layer.cornerRadius = 10
        print(indexpath)
        loadData()
        if tag == 1{
            navigationItem.title = "Document"
        }else if tag == 3{
            navigationItem.title = "Image"
        }else if tag == 2{
            navigationItem.title = "Video"
            downloadButton.isHidden = true
        }
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        if tag == 2 || tag == 3{
          SVProgressHUD.dismiss()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if tag == 1{
            SVProgressHUD.dismiss()
        }
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
    
    @IBAction func downloadButtonClicked(_ sender: Any) {
        if tag == 1{
            downloadData(name: "Document\(indexpath)")
        }else if tag == 3{
            downloadData(name: "Image\(indexpath)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    private func downloadData(name:String){
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    documentsURL.appendPathComponent(name)
                    return (documentsURL, [.removePreviousFile])
                }
        
                print(downloadUrl)
        Alamofire.download(downloadUrl, to: destination).downloadProgress { progress in // main queue by default
            print("Upload Progress: \(progress.fractionCompleted)")
            
            
            DispatchQueue.main.async() {
                let percentage = Float(progress.fractionCompleted) / Float(1.0)
                let x = Int(percentage*100)
                
                if(x == 100){
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    SVProgressHUD.dismiss()
                }else{
                    SVProgressHUD.showProgress(percentage, status: "Downloading (\(x)%)")
                    self.navigationController?.navigationBar.isUserInteractionEnabled = false
                }
            }
            
            
            }.responseData { response in
        
                    if response.result.isSuccess{
                        self.showSuccess(withMessage: "Download completed")
                    }else{
                        //TODO: if not success
                        self.showAlertForError(withMessage: "Something went wrong")
                    }
                }
    }
    
    
    private func showSuccess(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Completed", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Done", style: .cancel) { (UIAlertAction) in
            SVProgressHUD.dismiss()
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }

}
