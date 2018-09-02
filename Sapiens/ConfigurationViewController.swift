//
//  ConfigurationViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 26/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class ConfigurationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btLogout(_ sender: UIBarButtonItem) {
        
        print("Redirecionar para inicio")
        
        COREDATA.deleteLoginCore()
        let loginViewController = REST.logoutHome()
        self.present(loginViewController, animated:true, completion:nil)

        
    }
    
    
    

}
