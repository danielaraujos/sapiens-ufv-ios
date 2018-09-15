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
    case responseStatusCode(code:Int?)
    case noConectionInternet
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
            if REST.isConnectedToInternet() {
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
                    onFail(.responseStatusCode(code: response.response!.statusCode ?? 0))
                }
            }else {
                print("Sem conexão com a internet")
                onSucess(false)
                onFail(.noConectionInternet)
            }
            
        }
    }
    
    class func subjectResponse(user: User, onComplete: @escaping ([SubjectData]) -> Void, onFail: @escaping (RESTFail) -> ()){
        
        /*
         PASSAR PELO COREDATA ANTES DE ENTRAR AQUI.
         -> SE FOR NULO ENTRA NO REQUEST, SE NAO RECARREGA O VALOR DO BANCO.
         
         CASO O USAURIO QUERIA ATUALIZAR AS NOTAS, CLICAR EM ATUALIZAR. A ROTINA DELETA O BANCO
         E ELE ABRE O DECODE.
 
        */
        Alamofire.request(pathBase + "notas", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if REST.isConnectedToInternet() {
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        onFail(.noJson)
                        return
                    }
                    do{
                        let subjects = try JSONDecoder().decode([SubjectData].self, from: data)
                        onComplete(subjects)
                    }catch{
                        print("Erro no try")
                        onFail(.noDecoder)
                    }
                }else {
                    onFail(.responseStatusCode(code: response.response?.statusCode  ?? 0))
                }
            }else {
                print("Sem conexão com a internet")
                onFail(.noConectionInternet)
            }
        }
    }
    
    class func schedulesResponse(user: User, onComplete: @escaping (SubjectsDataT) -> Void, onFail: @escaping (RESTFail) -> ()){
        Alamofire.request(pathBase + "horarios", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if REST.isConnectedToInternet() {
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        onFail(.noJson)
                        return
                    }
                    do{
                        let subjects = try JSONDecoder().decode(SubjectsDataT.self, from: data)
                        onComplete(subjects)
                    }catch{
                        print("Erro no try")
                        onFail(.noDecoder)
                    }
                }else {
                    onFail(.responseStatusCode(code: response.response?.statusCode ?? 0))
                }
            }else {
                print("Sem conexão com a internet")
                onFail(.noConectionInternet)
            }
        }
    }
    
    class func logoutHome () -> LoginViewController{
        let loginViewController: LoginViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginViewController
    }
    
    class func isConnectedToInternet () -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
