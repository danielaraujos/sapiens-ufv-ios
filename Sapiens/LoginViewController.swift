//
//  LoginVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 15/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire
import UIKit
import SwiftyJSON


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPass: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.round()
    }
    
    @IBAction func loginBTN(_ sender: Any) {
        
        let usuario = User(user: userTF.text!, pass: passTF.text!)
    
        if(userTF.text == nil || (userTF.text?.isEmpty)!) {
            self.showAlert(title: "Ops...", message: "Campo usuário é obrigatório!")
            return
        }
        if(passTF.text == nil || (passTF.text?.isEmpty)!) {
            self.showAlert(title: "Ops...", message: "Campo senha é obrigatório!")
            return
        }
        
        REST.login(user: usuario, onSucess: { (sucess) in
            if sucess == true {
                print("LOGADO")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let tabs1 = storyBoard.instantiateViewController(withIdentifier: "Tabs") as! UITabBarController
                self.present(tabs1, animated:true, completion:nil)

            }else {
                print("FALSO")
            }
        }) { (error) in
            switch error {
            case .errorLogin(error: let er):
                print(er)
                self.showAlert(title: "Erro!", message: er)
            }
        }
    }

    func round () {
        button.layer.cornerRadius = 20;
        viewUser.layer.cornerRadius = 20;
        viewPass.layer.cornerRadius = 20;
        
        viewUser.clipsToBounds = true;
        button.clipsToBounds = true;
        viewPass.clipsToBounds = true;
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.esconderTeclado()
    }
    
    func esconderTeclado(){
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
}
