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
import CoreData

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPass: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutArround()
        userTF.delegate = self
        passTF.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if(self.user.user != "-1"){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let tabs1 = storyBoard.instantiateViewController(withIdentifier: "Tabs") as! UITabBarController
            self.present(tabs1, animated:true, completion:nil)
            print("COREDATA")
        }
    }
    
    @IBAction func loginBTN(_ sender: Any) {
        let usuario = User(user: userTF.text!, pass: passTF.text!)
        self.alert?.show(nil, hidden: nil)
        
        if self.validTextField(user: userTF, pass: passTF) == true {
            REST.login(user: usuario, onSucess: { (sucess) in
                if sucess == true {
                    self.saveUser(user: usuario)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let tabs1 = storyBoard.instantiateViewController(withIdentifier: "Tabs") as! UITabBarController
                    self.present(tabs1, animated:true, completion:nil)
                    DispatchQueue.main.async {
                        //self.returnUser()
                    }
                }
            }) { (error) in
                self.alert?.show(nil, hidden: nil)
                switch error {
                case .errorLogin(error: let message):
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: message, color: UIColor(named: "errorDefault"), type: "L")
                case .noResponse:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NORESPONSE, color: UIColor(named: "errorDefault"), type: "L")
                case .noJson:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NOJSON, color: UIColor(named: "errorDefault"), type: "L")
                case .nullResponse:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NULLJSON, color: UIColor(named: "errorDefault"), type: "L")
                case .responseStatusCode(code: let codigo):
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.returnStatus(valueStatus:codigo!), color: UIColor(named: "errorDefault"), type: "L")
                case .noConectionInternet:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NO_INTERNET, color: UIColor(named: "errorDefault"), type: "L")
                default:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_DEFAULT, color: UIColor(named: "errorDefault"), type: "L")
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        scroll.endEditing(true)
    }
    
    func layoutArround () {
        button.layer.cornerRadius = 20;
        viewUser.layer.cornerRadius = 20;
        viewPass.layer.cornerRadius = 20;
        
        viewUser.clipsToBounds = true;
        button.clipsToBounds = true;
        viewPass.clipsToBounds = true;
    }
    
    /*Function response validate textField*/
    func validTextField(user: UITextField, pass:UITextField!) -> Bool{
        if(user.text == nil || (user.text?.isEmpty)!) {
            self.alertShow(title: nil, message: "Campo usuário é obrigatório!", color: nil, type: "E")
            return false
        }else if(self.passTF.text == nil || (self.passTF.text?.isEmpty)!) {
            self.alertShow(title: nil, message: "Campo senha é obrigatório!", color: nil, type: "E")
            return false
        }else {
            return true
        }
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTF{
            passTF.becomeFirstResponder()
        }else if textField == passTF {
            self.loginBTN(Any)
        }
        return true
    }
}


