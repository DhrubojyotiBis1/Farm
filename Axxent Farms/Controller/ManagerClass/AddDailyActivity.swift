//
//  AddDailyActivity.swift
//  Farm
//
//  Created by Dhrubojyoti on 08/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SVProgressHUD
import BSImagePicker
import Photos

class AddDailyActivity: UITableViewController,ManagerPlotSelected,dateDelegate {
    func getActivityIdAndName(name: String, id: String) {
        self.activitySelected.text = name
        self.selectedActivityId = id
    }
    
    func getDate(date: String) {
        self.date = date
        self.selectedDate.text! = date
    }
    

    @IBOutlet weak var selectedDate: UITextField!
    
    var imageAsscets = [PHAsset]()
    var images = [UIImage]()
    var selectedDocumentURL = [URL]()
    var selectedImageData = [Data]()
    var selectedVideotURL = [URL]()
    let url = Url()
    var documentUrl = [String]()
    var tag = 0
    var imageUrl = [String]()
    var videoUrl = [String]()
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
        self.tabBarController!.tabBar.isHidden = true
        SVProgressHUD.dismiss()
    }
    


    @IBAction func selectPlot(_ sender: Any) {
        conditionToGoToSelectPlot = 1
      performSegue(withIdentifier: "goToSelectPlot", sender: sender)
    }
    
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        conditionToGoToSelectPlot = 2
        performSegue(withIdentifier: "goToSelectDate", sender: sender)
    }
    
    
    @IBAction func imageChooseButtonPressed(_ sender: Any) {
        tag = 1
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 6
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            print("Finish: \(assets)")
            self.imageAsscets = assets
            self.converAssetsToImage()
        }, completion: nil)
       
        
        
    }
    
    @IBAction func documentChooseButtonPressed(_ sender: Any) {
        tag = 2
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func videoChooseButtonPressed(_ sender: Any) {
        tag = 3
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        videoPicker.delegate = self
        videoPicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
        present(videoPicker, animated: true, completion: nil)
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        print("Entered")
        if comment.text! == "" || areaCovered.text! == "" || activitySelected.text == "" || selectedPlot.text! == "" || selectedDate.text == "" || details.text! == ""{
            
            print(comment.text! , self.areaCovered.text! , self.activitySelected.text! , self.selectedPlot.text! , self.selectedDate.text!, self.details.text!)
            
            print(comment.text! == "" || areaCovered.text! == "" || activitySelected.text == "" || selectedPlot.text! == "" || selectedDate.text == "" || details.text! == "")
            
            if comment.text! == ""{
                showAlertForError(withMessage: "Comment is required!")
            }else if areaCovered.text! == ""{
                showAlertForError(withMessage: "Area covered is required!")
            }else if activitySelected.text! == ""{
                showAlertForError(withMessage: "Activity is required!")
            }else if selectedPlot.text! == ""{
                showAlertForError(withMessage: "Plot is required!")
            }else if details.text! == ""{
                showAlertForError(withMessage: "Details are required!")
            }else if selectedDate.text! == ""{
                showAlertForError(withMessage: "Date is required!")
            }else{
                print("WTF")
            }
            
        }else{
            SVProgressHUD.show()
            networking()
        }
        
    }
    
    @IBAction func selectActivityButtonPressed(_ sender: Any) {
        conditionToGoToSelectPlot = 2
        performSegue(withIdentifier: "goToSelectPlot", sender: sender)
    }
    
    private func converAssetsToImage(){
        for i in 0..<imageAsscets.count{
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnel = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: imageAsscets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option) { (results, info) in
                thumbnel = results!
            }
            let data = thumbnel.jpegData(compressionQuality: 0.75)
            self.selectedImageData.append(data!)
        }
    }
    
    
    private func networking(){
        SVProgressHUD.show()
        let userId = String(describing:(UserDefaults.standard.value(forKey: "id"))!)
        let url = Url()
        let header: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"]
        let parameters = ["user_id":userId,"loan_type":plotId,"date":date,"act":selectedActivityId,"hect":areaCovered.text!,"det":details.text!,"cmts":comment.text!]
        
//
//        var r  = URLRequest(url: URL(string:url.ADD_DAILY_ACTIVITY)!)
//        r.httpMethod = "POST"
//        let boundary = "Boundary-\(UUID().uuidString)"
//        r.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        let docData : Data = selectedImageData[0]
//
//            r.httpBody = createBody(parameters: parameters,
//                                   boundary: boundary,
//                                   data: docData, mimeType: "image/jpg",
//                                   filename: "hello.jpg")
//
//        let task = URLSession.shared.dataTask(with: r as URLRequest) {
//                            data, response, error in
//
//                            if error != nil {
//                                print("error=\(String(describing: error))")
//                                return
//                            }
//
//                            // You can print out response object
//                            print("******* response = \(String(describing: response))")
//
//                            // Print out reponse body
//                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                            print("****** response data = \(responseString!)")
//
//
//                        }
//
//                        task.resume()
        
        
        Alamofire.upload(
            multipartFormData: {
                multipartFormData in
                if self.selectedDocumentURL.count > 0{
                    print("yes")
                    let documentData = try! Data(contentsOf: self.selectedDocumentURL[0])
                    let name = "\(self.selectedDocumentURL[0])"
                    let docData : Data = documentData
                multipartFormData.append(docData, withName: "docfile",fileName: String(name.split(separator: "/")[name.split(separator: "/").count - 1]), mimeType: "application/pdf")
                }

                if self.selectedVideotURL.count > 0{
                    let videoData = try! Data(contentsOf: self.selectedVideotURL[0])
                    let vidName = "\(self.selectedVideotURL[0])"
                    let vidData: Data = videoData
                    print("yes")
                multipartFormData.append(vidData, withName: "vidfile",fileName: String(vidName.split(separator: "/")[vidName.split(separator: "/").count - 1]), mimeType: "farm/mp4")
                }

                if self.selectedImageData.count > 0{
                    print("yes")
                for i in 0..<self.selectedImageData.count{
                    print("Yep")
                    let imageData:Data = self.selectedImageData[i]
                    multipartFormData.append(imageData, withName: "imgfile[]",fileName:"\(i).jpeg", mimeType: "image/jpeg")
                }
                }




                for (key, value) in parameters {
                    multipartFormData.append(((value).data(using: .utf8))!, withName: key)
                }

                print("Multi part Content -Type")
                print(multipartFormData.contentType)
                print("Multi part FIN ")
                print("Multi part Content-Length")
                print(multipartFormData.contentLength)
                print("Multi part Content-Boundary")
                print(multipartFormData.boundary)

        },
            to: url.ADD_DAILY_ACTIVITY,
            method: .post,
            headers: header,
            encodingCompletion: { encodingResult in

                switch encodingResult {

                case .success(let upload, _, _):
                    upload.responseString { response in
                        print(" responses ")
                        print(response)
                        print("end responses")

                        self.showSuccess(withMessage: "Activity has been added!")

                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.showAlertForError(withMessage: "SomeThing went wromt")
                }
        })
        
    }
    
    
//    func createBody(parameters: [String: String],
//                    boundary: String,
//                    data: Data,
//                    mimeType: String,
//                    filename: String) -> Data {
//        let body = NSMutableData()
//
//        let boundaryPrefix = "--\(boundary)\r\n"
//
//        for (key, value) in parameters {
//            body.appendString(boundaryPrefix)
//            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString("\(value)\r\n")
//        }
//
//        body.appendString(boundaryPrefix)
//        body.appendString("Content-Disposition: form-data; name=\"docfile\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
//        body.append(data)
//        body.appendString("\r\n")
//        body.appendString("--".appending(boundary.appending("--")))
//
//        return body as Data
//    }
    
    
    private func showAlertForError(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Retry", style: .cancel)
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    private func showSuccess(withMessage message : String){
        //TODO: check wether username or password enntered is wrong:
        let alert = UIAlertController(title: "Thnak You", message: message, preferredStyle: .alert)
        let reEnter = UIAlertAction(title: "Done", style: .default) { (UIAlertAction) in
            SVProgressHUD.dismiss()
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(reEnter)
        present(alert, animated: true, completion: nil)
    }
    
    
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
    
    
}


extension AddDailyActivity: UIDocumentPickerDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if tag == 1{
        }else if tag == 2{
            selectedDocumentURL = urls
            print("name: " , String("\(self.selectedDocumentURL[0])".split(separator: "/")["\(self.selectedDocumentURL[0])".split(separator: "/").count - 1]))
        }else {
            selectedVideotURL = urls
        }
    }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let videoUrl = info["UIImagePickerControllerReferenceURL"] as? URL{
            print("videourl: ", videoUrl)
            //trying compression of video
        }
        else{
            print("Something went wrong in  video")
        }
        
    }
    
    
}














extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}









//extension Data { mutating func append(string: String) { guard let data = string.data( using: .utf8, allowLossyConversion: true) else { return }; append(data) } }

//
//extension NSMutableData {
//
//    func appendString(string: String) {
//        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        append(data!)
//    }
//}


/*
 
 let documentData = try! Data(contentsOf: selectedDocumentURL[0])
 SVProgressHUD.show()
 let userId = String(describing:(UserDefaults.standard.value(forKey: "id"))!)
 let url = Url()
 let header: HTTPHeaders = [
 /* "Authorization": "your_access_token",  in case you need authorization header */
 "Content-type": "multipart/form-data"]
 let parameters = ["user_id":userId,"loan_type":plotId,"date":date,"act":selectedActivityId,"hect":areaCovered.text!,"det":details.text!,"cmts":comment.text!]
 
 
 let data : Data = documentData
 Alamofire.upload(
 multipartFormData: {
 multipartFormData in
 multipartFormData.append(data, withName: "docfile",fileName: "file.pdf", mimeType: "farm/txt")
 for (key, value) in parameters {
 multipartFormData.append(((value).data(using: .utf8))!, withName: key)
 }
 
 print("Multi part Content -Type")
 print(multipartFormData.contentType)
 print("Multi part FIN ")
 print("Multi part Content-Length")
 print(multipartFormData.contentLength)
 print("Multi part Content-Boundary")
 print(multipartFormData.boundary)
 
 },
 to: url.ADD_DAILY_ACTIVITY,
 method: .post,
 headers: header,
 encodingCompletion: { encodingResult in
 
 switch encodingResult {
 
 case .success(let upload, _, _):
 upload.responseString { response in
 print(" responses ")
 print(response)
 print("end responses")
 SVProgressHUD.dismiss()
 
 }
 case .failure(let encodingError):
 print(encodingError)
 SVProgressHUD.dismiss()
 }
 })
 
 */



/*
 
 
 
 ALTERNATIVE:
 
 
 
 //            let data : NSData = pdfData!
 //
 //            let boundary = generateBoundaryString()
 //            let uploadUrl = URL(string: url.ADD_DAILY_ACTIVITY)
 //            let request = NSMutableURLRequest(url: uploadUrl!)
 //            request.httpMethod = "POST"
 //            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-type")
 //            request.httpBody = createBodyWithParameters(parameters: parameters, filePathKey: "docfile", imageDataKey: data, boundary: boundary) as Data
 //
 //
 //            let task = URLSession.shared.dataTask(with: request as URLRequest) {
 //                data, response, error in
 //
 //                if error != nil {
 //                    print("error=\(String(describing: error))")
 //                    return
 //                }
 //
 //                // You can print out response object
 //                print("******* response = \(String(describing: response))")
 //
 //                // Print out reponse body
 //                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
 //                print("****** response data = \(responseString!)")
 //
 //                do {
 //                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
 //
 //                    print(json!)
 //                }catch
 //                {
 //                    print(error)
 //                }
 //
 //            }
 //
 //            task.resume()
 //    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
 //        let body = NSMutableData()
 //
 //
 //        if parameters != nil {
 //            for (key, value) in parameters! {
 //                body.appendString(string: "--\(boundary)\r\n")
 //
 //                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
 //                body.appendString(string: "\(value)\r\n")
 //            }
 //        }
 //
 //        let filename = "document.txt"
 //        let mimetype = "doc/txt"
 //
 //        body.appendString(string: "--\(boundary)\r\n")
 //        body.appendString(string:"Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
 //        body.appendString(string:"Content-Type: \(mimetype)\r\n\r\n")
 //        body.append(imageDataKey as Data)
 //        body.appendString(string:"\r\n")
 //        body.appendString(string:"--\(boundary)--\r\n")
 //
 //        return body
 //    }
 
 //    func generateBoundaryString() -> String {
 //        return "Boundary-\(NSUUID().uuidString)"
 //    }
 
 
 
 */
