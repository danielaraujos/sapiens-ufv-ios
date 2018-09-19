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
import UserNotifications

enum RESTFail {
    case errorLogin(error: String)
    case noResponse
    case noJson
    case nullResponse
    case noDecoder
    case responseStatusCode(code:Int?)
    case noConectionInternet
    case alertData
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
    
    static let localStorageSubject = "LocalSubject"
    static let localStorageSchedules = "LocalSchedules"
    static let localStorageNotifications = "isNotification"
    static let localStorageTime = "isTime"
    
    
    private static let sessionManager = Alamofire.SessionManager(configuration: configuration)
    
    private static let defaults = UserDefaults.standard
    
    /*
     FUNÇÃO RESPONSAVEL POR REALIZAR O LOGIN DO APLICATIVO
     */
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
    
    /*
     FUNÇÃO RESPONSAVEL PELA VERIFICAÇÃO DE NOTAS. CASO LOCAL STORAGE ESTEJA NULO, ELE ATUALIZA AS INFORMACOES.
     CASO O LOCAL STORATE ESTEJA DIFERENTE DO SAPIENS, ELE MOSTRARÁ UMA MENSAGEM PARA VARIFICAÇÃO
     */
    class func subjectResponse(user: User, onComplete: @escaping ([SubjectData]) -> Void, onFail: @escaping (RESTFail) -> ()){
        
        Alamofire.request(pathBase + "notas", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if let storageOff = defaults.data(forKey: REST.localStorageSubject) {
                /*CASO O STORAGE ESTEJA COM INFORMACOES ELE ENTRARÁ AQUI*/
                do{
                    let subjects = try JSONDecoder().decode([SubjectData].self, from: storageOff)
                    print("LOCAL STORAGE")
                    onComplete(subjects)
                }catch{
                    print("Erro no try")
                    onFail(.noDecoder)
                }
                if REST.isConnectedToInternet() {
                    if response.data != storageOff {
                        print("A versão atual está desatualizada! \(String(describing: response.data)) - \(storageOff)" )
                        onFail(.alertData)
                    }else {
                        print("Está igual :-)")
                    }
                }
            }else {
                /*CASO A PRIMEIRA VERIFICACAO OCORRA UM ERRO, ELE ATUALIZA OS DADOS.*/
                if REST.isConnectedToInternet() {
                    if response.response?.statusCode == 200 {
                        guard let data = response.data else {
                            onFail(.noJson)
                            return
                        }
                        do{
                            let subjects = try JSONDecoder().decode([SubjectData].self, from: data)
                            print("INTERNET")
                            defaults.set(data, forKey: REST.localStorageSubject)
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
    }
    
    class func schedulesResponse(user: User, onComplete: @escaping (SubjectsDataT) -> Void, onFail: @escaping (RESTFail) -> ()){
        Alamofire.request(pathBase + "horarios", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
             if let storageOff = defaults.data(forKey: REST.localStorageSchedules) {
                /*CASO O STORAGE ESTEJA COM INFORMACOES ELE ENTRARÁ AQUI*/
                do{
                    let subjects = try JSONDecoder().decode(SubjectsDataT.self, from: storageOff)
                    onComplete(subjects)
                    
                }catch{
                    print("Erro no try")
                    onFail(.noDecoder)
                }
                if REST.isConnectedToInternet() {
                    if response.data != storageOff {
                        print("A versão atual está desatualizada! \(String(describing: response.data)) - \(storageOff)" )
                        onFail(.alertData)
                    }else {
                        print("Está igual :-)")
                    }
                }
                
             }else {
                if REST.isConnectedToInternet() {
                    if response.response?.statusCode == 200 {
                        guard let data = response.data else {
                            onFail(.noJson)
                            return
                        }
                        do{
                            let subjects = try JSONDecoder().decode(SubjectsDataT.self, from: data)
                            print("INTERNET")
                            defaults.set(data, forKey: REST.localStorageSchedules)
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
    }
    
    /*Classe criada para verificar se ouve atualizacao de alguma materia*/
    class func checkUpdate(user: User,onComplete: @escaping (Bool) -> Void){
        Alamofire.request(pathBase + "notas", method: .post, parameters: parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            guard let data = response.data else {
                print("Erro na requisicao")
                onComplete(false)
                return
            }
            if let storageOff = defaults.data(forKey: REST.localStorageSubject) {
                var arrayOf : [String] = [],arrayOn :  [String] = []
                /*CASO O STORAGE ESTEJA COM INFORMACOES ELE ENTRARÁ AQUI*/
                do{
                    let subjectsOff = try JSONDecoder().decode([SubjectData].self, from: storageOff)
                    let subjectsOn = try JSONDecoder().decode([SubjectData].self, from: data)
                    
                    for i in subjectsOff{if let notas = i.nota?.notas{for j in notas {arrayOf.append(j.valor)}}}
                    for a in subjectsOn{if let notas2 = a.nota?.notas{for b in notas2 {arrayOn.append(b.valor)}}}
                    
                    if arrayOn != arrayOf {onComplete(true)}else{onComplete(false)}
                }catch{
                    onComplete(false)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    class func pushNotifications (){
        if defaults.bool(forKey: self.localStorageNotifications) == true {
            print("Cliquei para ter notificacao")
            let id = String(Date().timeIntervalSince1970)
            let content = UNMutableNotificationContent()
            content.title = "Atualização no Sapiens"
            content.body = "Ocorreu alguma atualização em suas notas!"
            
            content.sound = UNNotificationSound(named: "out.caf")
            content.categoryIdentifier = "Atualização"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    
    class func deleteStorage() {
        // Remover as notas
        defaults.removeObject(forKey: REST.localStorageSubject)
        defaults.removeObject(forKey: REST.localStorageSchedules)
        defaults.synchronize()
        print("Dados do Storage foi deletado com sucesso!")
    }
    
    class func logoutHome () -> LoginViewController{
        let loginViewController: LoginViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return loginViewController
    }
    
    class func isConnectedToInternet () -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
