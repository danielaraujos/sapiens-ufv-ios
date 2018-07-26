//
//  REST.swift
//  Sapiens
//
//  Created by Daniel Araújo on 22/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RESTFail {
    case errorLogin(error: String)
    case noResponse
    case noJson
    case nullResponse
    case noDecoder
}

class REST {
    private static let pathBase = "http://danielaraujos.com/webservicesapiens/index.php?info="
    
    private static let configuration : URLSessionConfiguration = {
        var config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return config
    }()
    
    class func parametersAlamofire(user: String, pass: String) -> [String: String]{
        return [
            "user": user,
            "pass": pass
        ]
    }
    
    
    private static let sessionManager = Alamofire.SessionManager(configuration: configuration)
    
    
    class func login (user: User, onSucess: @escaping (Bool) -> Void , onFail: @escaping (RESTFail) -> Void){
        Alamofire.request(pathBase + "login", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { response in
            
            if (response.response?.statusCode == 200){
                if let json: AnyObject = response.result.value as? AnyObject {
                    if response.result.value != nil{
                        let conversaoJson = JSON(json)
                        if conversaoJson["logado"] == true {
                            onSucess(true)
                        }else{
                            onSucess(false)
                            onFail(.errorLogin(error: "\(conversaoJson["erro"])"))
                        }
                    }else{
                        onSucess(false)
                        onFail(.nullResponse)
                    }
                }else {
                    onSucess(false)
                    onFail(.noJson)
                }
            }else {
                onSucess(false)
                onFail(.noResponse)
            }
        }
    }
    
    class func subjectResponse(user: User, onComplete: @escaping ([SubjectData]) -> Void, onFail: (RESTFail) -> ()){
        Alamofire.request(pathBase + "notas", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {
                print("Erro no response data")
                return
            }
            do{
                let subjects = try JSONDecoder().decode([SubjectData].self, from: data)
                onComplete(subjects)
            }catch{
                print("Erro no try")
            }
            
        }
    }
    
    class func schedulesResponse(user: User, onComplete: @escaping (SubjectsDataT) -> Void){
        Alamofire.request(pathBase + "horarios", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {
                print("Erro no response data")
                return
            }
            do{
                let subjects = try JSONDecoder().decode(SubjectsDataT.self, from: data)
                onComplete(subjects)
            }catch{
                print("Erro no try")
            }
            
        }
    }
    
}
