//
//  Home.swift
//  Farm
//
//  Created by Dhrubojyoti on 09/02/19.
//  Copyright © 2019 Dhrubojyoti. All rights reserved.
//

import UIKit

class Home: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        //TODO: removes the back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: nil)
    }

    @IBAction func logOutButtonclicked(_ sender: UIButton) {
        //TODO: takes the user to the login page when logout button is clicked
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        let viewController = storyboard!.instantiateViewController(withIdentifier: "Login")
        let navigationViewController = UINavigationController(rootViewController: viewController)
        let share = UIApplication.shared.delegate as? AppDelegate
        share?.window?.rootViewController = navigationViewController
        share?.window?.makeKeyAndVisible()

        }
}
