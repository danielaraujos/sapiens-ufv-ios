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
    
    var userBD : UserDataBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.round()
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
        
        self.errorAlert?.show(nil, hidden: nil)
        
        if(userTF.text == nil || (userTF.text?.isEmpty)!) {
            self.showError(message: "Campo usuário é obrigatório!")
            return
        }
        if(passTF.text == nil || (passTF.text?.isEmpty)!) {
            self.showError(message: "Campo senha é obrigatório!")
            return
        }
        
        REST.login(user: usuario, onSucess: { (sucess) in
            if sucess == true {
                print("LOGADO")
                self.saveCore()
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let tabs1 = storyBoard.instantiateViewController(withIdentifier: "Tabs") as! UITabBarController
                self.present(tabs1, animated:true, completion:nil)
                DispatchQueue.main.async {
                    COREDATA.loginUserCore()
                }
                
            }else {
                print("FALSO")
            }
        }) { (error) in
            self.errorAlert?.show(nil, hidden: nil)
            switch error {
            case .errorLogin(error: let message):
                self.showError(message: message)
            case .noResponse:
                self.showError(message: MESSAGE.MESSAGE_NORESPONSE)
            case .noJson:
                self.showError(message: MESSAGE.MESSAGE_NOJSON)
            case .nullResponse:
                self.showError(message: MESSAGE.MESSAGE_NULLJSON)
            case .responseStatusCode(code: let codigo):
                self.showError(message: MESSAGE.returnStatus(valueStatus:codigo!))
            case .noConectionInternet:
                self.showError(message: MESSAGE.MESSAGE_NO_INTERNET)
            default:
                self.showError(message: MESSAGE.MESSAGE_DEFAULT)
            }
        }
        
    }

    func saveCore (){
        if(self.userBD == nil ){
            self.userBD = UserDataBase(context: context)
        }
        self.userBD?.user = self.userTF.text
        self.userBD?.pass = self.passTF.text

        do {
            try context.save()
        }catch{
            print(error.localizedDescription)
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
    
}
