//
//  splash.swift
//  Farm
//
//  Created by Dhrubojyoti on 09/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class splash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if ((UserDefaults.standard.value(forKey: "username") != nil) && (UserDefaults.standard.value(forKey: "password") != nil) && (UserDefaults.standard.value(forKey: "type") != nil)){
            
            let type = Int(String(describing: (UserDefaults.standard.value(forKey: "type"))!))!
            
            switch type {
            case 1:
                performSegue(withIdentifier: "goToAdmin", sender: nil)
                break
            case 2:
            //TODO: performsegur that takes to manager
                performSegue(withIdentifier: "goToManager", sender: nil)
                break
            case 3:
            //TODO: performsegue that takes to the Auditor
                performSegue(withIdentifier: "goToAdmin", sender: nil)
                break
            default:
                print("Error")
                break
            }
        }else{
           performSegue(withIdentifier: "goToLogin", sender: nil)
        }
        
    }
}
