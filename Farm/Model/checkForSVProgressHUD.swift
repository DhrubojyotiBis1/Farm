//
//  upload.swift
//  Farm
//
//  Created by Dhrubojyoti on 10/03/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit
import SVProgressHUD

class checkForSVProgressHUD{
 
    func checkForSVProgressHUD(withFlag flag:Int){
        if flag == 1{
            SVProgressHUD.dismiss()
        }else{
            SVProgressHUD.show()
        }
    }
    
    
}
