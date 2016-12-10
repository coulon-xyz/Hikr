//
//  SettingsViewController.swift
//  Hikr
//
//  Created by Julien Coulon on 08/12/2016.
//  Copyright © 2016 CoulonXYZ. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        // firebase logout
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }

        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        

    }
    
    
}
