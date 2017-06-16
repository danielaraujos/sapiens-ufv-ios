//
//  LoginVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 15/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func loginBTN(_ sender: Any) {
        if(userTF.text == nil || (userTF.text?.isEmpty)!) {
            self.showAlert(title: "Ops...", message: "Campo usuário é obrigatório!")
            return
        }
        if(passTF.text == nil || (passTF.text?.isEmpty)!) {
            self.showAlert(title: "Ops...", message: "Campo senha é obrigatório!")
            return
            
        }
        
        //Login function
        Api.Instance.login(user: userTF.text!, password: passTF.text!)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let tabs1 = storyBoard.instantiateViewController(withIdentifier: "Tabs") as! UITabBarController
        self.present(tabs1, animated:true, completion:nil)

        
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    


}
