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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutArround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(COREDATA.loginUserCore().user != "-1"){
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
                    COREDATA.saveUserResponse(user:self.userTF, pass: self.passTF, context: self.context)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let tabs1 = storyBoard.instantiateViewController(withIdentifier: "Tabs") as! UITabBarController
                    self.present(tabs1, animated:true, completion:nil)
                    DispatchQueue.main.async {
                        COREDATA.loginUserCore()
                    }
                }
            }) { (error) in
                self.alert?.show(nil, hidden: nil)
                switch error {
                case .errorLogin(error: let message):
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: message, color: UIColor(named: "errorDefault"), type: "T")
                case .noResponse:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NORESPONSE, color: UIColor(named: "errorDefault"), type: "T")
                case .noJson:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NOJSON, color: UIColor(named: "errorDefault"), type: "T")
                case .nullResponse:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NULLJSON, color: UIColor(named: "errorDefault"), type: "T")
                case .responseStatusCode(code: let codigo):
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.returnStatus(valueStatus:codigo!), color: UIColor(named: "errorDefault"), type: "T")
                case .noConectionInternet:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NO_INTERNET, color: UIColor(named: "errorDefault"), type: "T")
                default:
                    self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_DEFAULT, color: UIColor(named: "errorDefault"), type: "T")
                }
            }
        }
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
