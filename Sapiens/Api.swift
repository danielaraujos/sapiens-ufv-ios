//
//  Api.swift
//  Sapiens
//
//  Created by Daniel Araújo on 15/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import UIKit
import SwiftyJSON

class Api {
    
    private static var _instance = Api()
    static var Instance : Api {
        return _instance
    }
    
    private var manager: SessionManager
    private init() {
        self.manager = Alamofire.SessionManager.default
    }
    
    
    func login(user: String, password: String) {
        let parameters: [String: String] = [
            "user": user,
            "pass": password
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(BASE_URL + "login", method:.post, parameters:parameters,encoding: JSONEncoding.default, headers:headers).validate(statusCode: 200..<300).responseJSON { response in
            
            if let json: AnyObject = response.result.value! as AnyObject {
                
                let post = JSON(json)
                if post["logado"] == true {
                    print("LOGADO")

                } else {
                    print(post["erro"])
                    //self.showAlert(title: "Erro!", message: post["erro"])
                }
                
            }
        }
        
    }// End Login
    
    
    func logout(){
        
    }
    
   


    
}
