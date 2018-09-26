//
//  ProviderFecth.swift
//  Sapiens
//
//  Created by Daniel Araújo on 21/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProviderFecth {
    
    static let config = Configuration.shared
    
    class func subjectFetch(user: User, onComplete: @escaping ([SubjectData]) -> Void, onFail: @escaping (RESTFail) -> ()){
        Alamofire.request(REST.pathBase + "notas", method: .post, parameters: REST.parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if REST.isConnectedToInternet() {
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        onFail(.noJson)
                        return
                    }
                    do{
                        config.defaults.removeObject(forKey: UserDefaultsKeys.storageSubject.rawValue)
                        let subjects = try JSONDecoder().decode([SubjectData].self, from: data)
                        config.storageSubject = data
                        
                        onComplete(subjects)
                        config.defaults.synchronize()
                    }catch{
                        onFail(.noDecoder)
                    }
                }else {
                    onFail(.responseStatusCode(code: response.response?.statusCode  ?? 0))
                }
            }else {
                onFail(.noConectionInternet)
            }
        }
    }
    
    
    class func schedulesFecth(user: User, onComplete: @escaping (SubjectsDataT) -> Void, onFail: @escaping (RESTFail) -> ()){
        Alamofire.request(REST.pathBase + "horarios", method: .post, parameters: REST.parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if REST.isConnectedToInternet() {
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        onFail(.noJson)
                        return
                    }
                    do{
                        config.defaults.removeObject(forKey: UserDefaultsKeys.storageSchedules.rawValue)
                        let subjects = try JSONDecoder().decode(SubjectsDataT.self, from: data)
                        config.storageSchedules = data
                        onComplete(subjects)
                        config.defaults.synchronize()
                    }catch{
                        onFail(.noDecoder)
                    }
                }else {
                    onFail(.responseStatusCode(code: response.response?.statusCode ?? 0))
                }
            }else {
                onFail(.noConectionInternet)
            }
        }
    }
    
}
